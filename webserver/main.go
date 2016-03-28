package main

import (
    "fmt"
    "net"
    "net/http"
    "crypto/md5"
    "encoding/hex"
    "strings"
)

func NetworkAddress(cidr string) string {

    _, IPnet, err := net.ParseCIDR(cidr)

    if err != nil {
        fmt.Println(err)
    }

    return IPnet.String()
}

func GetMD5Hash(text string) string {
    hasher := md5.New()
    hasher.Write([]byte(text))
    return hex.EncodeToString(hasher.Sum(nil))
}

func redirectToVideo(w http.ResponseWriter, r *http.Request) {

    // ip, _, _ := net.SplitHostPort(r.RemoteAddr)
    ip := r.Header.Get("X-Real-IP")

    cidr := NetworkAddress(strings.Join([]string{ip, "24"}, "/"))
    s := []string{"no-more-secrets-", cidr}
    data := strings.Join(s, "")
    hash := GetMD5Hash(data);

    http.Redirect(w, r, "/video?h=" + hash, http.StatusFound)
}

func handler(w http.ResponseWriter, r *http.Request) {

    fmt.Fprintf(w, "<html><head></head><body>Try /go-to-video!</body></html>")
}

func videoHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<html><head></head><body>highly secretive video</body></html>")
}

func main() {
    http.HandleFunc("/", handler)
    http.HandleFunc("/go-to-video", redirectToVideo)
    http.HandleFunc("/video", videoHandler)
    http.ListenAndServe(":80", nil)
}
