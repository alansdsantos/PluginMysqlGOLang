package main

// #include <string.h>
// #include <stdbool.h>
// #include <mysql.h>
// #cgo CFLAGS: -O3 -I/usr/include/mysql -fno-omit-frame-pointer
import "C"
import (
	"net/http"
	"unsafe"
	"log"
	"os"
	"fmt"
	"io/ioutil"
)

const logging = true
const arrLength = 1 << 30

//enable logging
func generateLogFile(msgprnt string) string{

	if (logging){
		LOG_FILE := "/tmp/myapp_log"

		logFile, err := os.OpenFile(LOG_FILE, os.O_APPEND|os.O_RDWR|os.O_CREATE, 0644)

		if err != nil {
			log.Panic("Error while opening log file: " + msgprnt + "-" + fmt.Sprint(err))
		}

		defer logFile.Close()
		log.SetOutput(logFile)
		log.SetFlags(log.Lshortfile | log.LstdFlags)
		log.Println(msgprnt)
	}

	return ""
}

//download the file and return it to caller
func fetchResponse(url string) (string, int){

	resp, err := http.Get(url)
	
	if err != nil {
		generateLogFile("Error while downloading GET: " + url + "-" + fmt.Sprint(err))
		return "", -1
	}
	
	defer resp.Body.Close()
	
	body, err := ioutil.ReadAll(resp.Body)
	
    if err != nil {
        generateLogFile("Error while downloading READING: " + url + "-" + fmt.Sprint(err))
		return "", -1
    }
	
	tamanho:=len(body)	
	return string(body), tamanho
}

//convert to properly type
func msg(message *C.char, s string) {
	m := C.CString(s)
	defer C.free(unsafe.Pointer(m))

	C.strcpy(message, m)
}

//export http_download_init
func http_download_init(initid *C.UDF_INIT, args *C.UDF_ARGS, message *C.char) C.my_bool {
	
	//check properly parameters
	if args.arg_count < 1 {
		msg := `http_download(url string) requires url`
		generateLogFile("Error when INIT function: " + msg)
		
		return 1
	}
		
	return 0
}

	
//export http_download
func http_download(initid *C.UDF_INIT, args *C.UDF_ARGS, result *C.char, length *uint64,
	null_value *C.char, message *C.char) *C.char {
	
	//var ret []byte
	//result = (*C.char) (unsafe.Pointer(&ret))
	filecontent, filesize := fetchResponse(C.GoString(*args.args))
	
	if (filesize <= 0) {
		return C.CString("Error when trying making request, please enable and check logs.")
	}
	
	//this area really required values for mysql return
	*null_value = 0
	*length = uint64(filesize)
	initid.ptr = C.CString(filecontent)	
	
	return C.CString(filecontent)
}

func main() {}
