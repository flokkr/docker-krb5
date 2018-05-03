package main

import (
	"github.com/progrium/go-basher"
	"net/http"
	"strings"
	"path"
	"os"
	"log"
	"io/ioutil"
	"flag"
)

var bash, _ = basher.NewContext("/bin/bash", false)
var keyDir = "/data/"

func init() {
	bash.Source("bash/keytab.sh", Asset)
	bash.Source("bash/root.sh", Asset)
	bash.Source("bash/issue.sh", Asset)
}

func checkTrustFile() (string) {
	trustFile := path.Join(keyDir, "trust.keystore")
	if _, err := os.Stat(trustFile); os.IsNotExist(err) {
		_, err := bash.Run("root", []string{keyDir})
		if err != nil {
			log.Printf(err.Error())
		}
	}
	return trustFile
}

func checkCertFile(name string) (string) {
	certFile := path.Join(keyDir, name + ".keystore")
	if _, err := os.Stat(certFile); os.IsNotExist(err) {
		_, err := bash.Run("issue", []string{keyDir, name})
		if err != nil {
			log.Printf(err.Error())
		}
	}
	return certFile
}

func checkKeytab(host string, serviceName string) string {
	principal := serviceName + "/" + host + "@EXAMPLE.COM"
	keytabFile := path.Join(keyDir, serviceName + "." + host + ".keytab")
	if _, err := os.Stat(keytabFile); os.IsNotExist(err) {
		args := []string{principal, keytabFile}
		_, err := bash.Run("keytab", args)
		if err != nil {
			log.Printf(err.Error())
		}

	}
	return keytabFile

}

func trustStoreGenerator(w http.ResponseWriter, r *http.Request) {
	trustFile := checkTrustFile()
	content, _ := ioutil.ReadFile(trustFile)
	w.Write(content)
}

func certGenerator(w http.ResponseWriter, r *http.Request) {
	checkTrustFile()
	var segments = strings.Split(r.URL.String(), "/")
	certFile := checkCertFile(segments[2])
	content, _ := ioutil.ReadFile(certFile)
	w.Write(content)
}

func keytabGenerator(w http.ResponseWriter, r *http.Request) {
	var segments = strings.Split(r.URL.String(), "/")
	host := segments[2]
	serviceName := segments[3]
	keytabFile := checkKeytab(host, serviceName)
	content, _ := ioutil.ReadFile(keytabFile)
	w.Write(content)
}

func main() {
	port := flag.String("port", "8081", "Http port to listen on")
	flag.Parse()

	http.HandleFunc("/keystore/", certGenerator)
	http.HandleFunc("/truststore", trustStoreGenerator)
	http.HandleFunc("/keytab/", keytabGenerator)
	print("Issuer is listening on : " + *port)
	if err := http.ListenAndServe(":" + *port, nil); err != nil {
		log.Fatal(err)
	}

}
