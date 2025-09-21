package main

import (
	"bytes"
	"fmt"
	"io/fs"
	"os"
	"path"
	"strings"
)

var (
	outputExe       = "game"
	compilerExe     = "g++"
	compilerOptions = []string{
		"-m64",
		"-fno-strict-aliasing",
		"-pedantic",
		"-Wall",
		"-Wextra",
		"-Wno-deprecated-declarations",
		"-Wno-unused-parameter",
		"-Wno-format-truncation",
		"-std=c++11",
		"-pthread",
		"-DOS_LINUX=1",
		"-DARCH_X64=1",
	}
	debugOptions   = []string{"-g", "-Og", "-DENABLE_ASSERTIONS=1"}
	releaseOptions = []string{"-O2"}
	linkerOptions  = []string{
		"-Wl,-t",
		"-lcrypto",
	}
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("USAGE: makefile.exe SRCDIR")
		os.Exit(1)
	}

	sourceDir := os.Args[1]
	buildDir := path.Join(path.Dir(sourceDir), "build")

	type Object struct{ obj, src string }
	objectFiles := []Object{}
	headerFiles := []string{}

	fs.WalkDir(os.DirFS(sourceDir), ".",
		func(rel string, d fs.DirEntry, err error) error {
			if err == nil && !d.IsDir() {
				ext := path.Ext(rel)
				switch ext {
				case ".cpp", ".cxx", ".cc", ".c":
					src := rel
					obj := rel[:len(src)-len(ext)] + ".obj"
					objectFiles = append(objectFiles, Object{obj, src})
				case ".hpp", ".hxx", ".hh", ".h":
					hdr := rel
					headerFiles = append(headerFiles, hdr)
				}
			}
			return nil
		})

	output := bytes.Buffer{}

	// VARIABLES
	fmt.Fprintf(&output, "SRCDIR = %v\n", sourceDir)
	fmt.Fprintf(&output, "BUILDDIR = %v\n", buildDir)
	fmt.Fprintf(&output, "OUTPUTEXE = %v\n", outputExe)
	fmt.Fprint(&output, "\n")

	fmt.Fprintf(&output, "CC = %v\n", compilerExe)
	fmt.Fprintf(&output, "CFLAGS = %v\n", strings.Join(compilerOptions, " "))
	fmt.Fprintf(&output, "LFLAGS = %v\n", strings.Join(linkerOptions, " "))
	fmt.Fprint(&output, "\n")

	// DEBUG SWITCH
	fmt.Fprint(&output, "DEBUG ?= 0\n")
	fmt.Fprint(&output, "ifneq ($(DEBUG), 0)\n")
	fmt.Fprintf(&output, "\tCFLAGS += %v\n", strings.Join(debugOptions, " "))
	fmt.Fprint(&output, "else\n")
	fmt.Fprintf(&output, "\tCFLAGS += %v\n", strings.Join(releaseOptions, " "))
	fmt.Fprint(&output, "endif\n\n")

	// HEADERS
	fmt.Fprint(&output, "HEADERS =")
	for _, header := range headerFiles {
		fmt.Fprintf(&output, " $(SRCDIR)/%v", header)
	}
	fmt.Fprint(&output, "\n\n")

	// EXECUTABLE
	fmt.Fprint(&output, "$(BUILDDIR)/$(OUTPUTEXE):")
	for _, object := range objectFiles {
		fmt.Fprintf(&output, " $(BUILDDIR)/%v", object.obj)
	}
	fmt.Fprint(&output, "\n")
	fmt.Fprint(&output, "\t$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS)\n\n")

	// OBJECTS
	for _, object := range objectFiles {
		fmt.Fprintf(&output, "$(BUILDDIR)/%v: $(SRCDIR)/%v $(HEADERS)\n", object.obj, object.src)
		fmt.Fprint(&output, "\t@mkdir -p $(@D)\n")
		fmt.Fprint(&output, "\t$(CC) -c $(CFLAGS) -o $@ $<\n\n")
	}

	// PHONY
	fmt.Fprint(&output, ".PHONY: clean\n\n")
	fmt.Fprint(&output, "clean:\n\t@rm -rf $(BUILDDIR)\n\n")

	if err := os.WriteFile("Makefile", output.Bytes(), 0644); err != nil {
		fmt.Printf("failed to write Makefile: %v\n", err)
		os.Exit(1)
	}

	return
}
