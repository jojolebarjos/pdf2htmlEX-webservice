package main

import (
    "fmt"
    "io"
    "io/ioutil"
    "net/http"
    "os"
    "os/exec"
)

// Extract PDF content
func convertHandler(w http.ResponseWriter, r *http.Request) {
    
    // Create temporary file to hold PDF data
    tmpFile, _ := ioutil.TempFile("", "*.pdf")
    tmpPath := tmpFile.Name()
    defer os.Remove(tmpPath)
    
    // Save attachment
    attachmentFile, _, attachmentError := r.FormFile("file")
    if attachmentError != nil {
        w.WriteHeader(400)
        fmt.Fprintf(w, "No attachment")
        fmt.Printf("%s -> %s %s %s -> 400\n", r.RemoteAddr, r.Proto, r.Method, r.URL)
        return
    }
    defer attachmentFile.Close()
    io.Copy(tmpFile, attachmentFile)
    tmpFile.Sync()
    
    // Run command
    resultPath := fmt.Sprintf("..%s.html", tmpPath)
    cmd := exec.Command("pdf2htmlEX", tmpPath, resultPath)
    cmdOutput, cmdError := cmd.CombinedOutput()
    if cmdError != nil {
        w.WriteHeader(400)
        w.Write(cmdOutput)
        fmt.Printf("%s -> %s %s %s -> 400\n", r.RemoteAddr, r.Proto, r.Method, r.URL)
        return
    }
    
    // Open result
    resultFile, _ := os.Open(resultPath)
    defer resultFile.Close()
    defer os.Remove(resultPath)
    w.Header().Set("Content-Type", "application/xhtml+xml")
    io.Copy(w, resultFile)
    fmt.Printf("%s -> %s %s %s -> 200\n", r.RemoteAddr, r.Proto, r.Method, r.URL)
    
}

// Entry point
func main() {
    fmt.Printf("Listening on port 8080\n")
    http.HandleFunc("/convert", convertHandler)
    http.ListenAndServe(":8080", nil)
}
