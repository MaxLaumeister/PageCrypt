#' Encrypt and HTML Page
#' @description This is copy/pasta from the PageCrypt project by Max Laumeister translated for use as an R function. Makes use of the V8 package to create a javascript environment in R.
#' @param file a character string. path/to/html.file
#' @param password a character string. Password that unlocks file contents
#' @param out_file optional. file path and name for new file.
#'
#' @return Saves an encrypted HTML file to same path as original file input by appending "-protected.html", unless out_file is specified.
#' @export
#' @import V8
#' @examples
#' if(interactive()){
#'  file <- system.file("example.html", package = "pagecryptr")
#'  pagecryptr(file, "password", out_file = "~/Desktop/encrypted-file.html")
#' }
#'
pagecryptr <- function(file, password, out_file = NULL){

  # check if file is an .html
  if(substr(file, nchar(file)-4, nchar(file)) != ".html"){
    stop("File is not an html file")
  }

  #check if password is a character
  if(!is.character(password)){
    stop("Password must be a character string")
  }

  # create a JS environment
  js <- V8::v8()

  # source js file (now legacy files)
  js$source(system.file("js/aes.js", package = "pagecryptr"))
  js$source(system.file("js/pbkdf2.js", package = "pagecryptr"))

  # pass password into js environment
  js$assign("password", password[[1]])

  #read the unprotected HTML into R and assign into JS
  contents <- paste(readLines("~/Desktop/try.html"), collapse = " ")
  js$assign("fileConts", contents)

  # JS copy/pasted from the PageCrypt HTML index.html
  js$eval("function encryptFile(contents, password) {
              var salt = CryptoJS.lib.WordArray.random(256/8);
              var iv = CryptoJS.lib.WordArray.random(128/8);
              var key = CryptoJS.PBKDF2(password, salt, { keySize: 256/32, iterations: 100 });
              var encrypted = CryptoJS.AES.encrypt(contents, key, {iv: iv});
              return {salt: salt, iv: iv, data: encrypted};
          }")

  js$eval("var encryptedFile = encryptFile(fileConts, password);
           var salt = CryptoJS.enc.Base64.stringify(encryptedFile.salt);
           var iv = CryptoJS.enc.Base64.stringify(encryptedFile.iv);
           var cipherText = CryptoJS.enc.Base64.stringify(encryptedFile.data.ciphertext);
           var encryptedJSON = JSON.stringify({salt: salt, iv: iv, data: cipherText});")

  # return the encrytped JSON back into R
  encrypted_payload <- js$get("encryptedJSON")

  # get the decrypt template and inject encrypted contents
  template <- readLines(system.file("decryptTemplate.html", package = "pagecryptr"))
  encrypted_doc <- sub("/*{{ENCRYPTED_PAYLOAD}}*/", encrypted_payload, template, fixed = TRUE)

  # get file name and write
  if(is.null(out_file)){
  new_file <- sub(".html", "-protected.html", file, fixed = TRUE)
  } else {
    # check if file is an .html
    if(substr(out_file, nchar(out_file)-4, nchar(out_file)) != ".html"){
      stop("Out file must end in .html")
    }
   new_file <- out_file
  }

  writeLines(encrypted_doc, new_file)

}
