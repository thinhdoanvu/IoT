# Sending Email

## Enable chuc nang cho phep kem an toan
http://www.google.com/settings/security/lesssecureapps

## Huong dan cau hinh Email bang google developer
### Buoc 1. console.cloud.google.com
	Tao moi Project (Create project): SenEmailFromR
	Chon Project vua tao
### Buoc 2. Click API & Service
	Chon Library
### Buoc 3. Search: GmailAPI
### Buoc 4. Click ENABLE
### Buoc 5. Click CREATE CREDENTIALS
	Chon: API are using: Gmail API
	Chon: User data
		NEXT
	App Name: NTU SmartAgri
	User support: itspider2019@gmail.com
			la cai Email minh dang dang ky
	Developer contact: itspider2019@gmail.com
		SAVE AND CONTINUE
		SAVE AND CONTINUE
		(2 lan, keo xuong se thay)
### Buoc 6. Click OAuth Client ID
	Application Type: Desktop App
	Apllication name: NTU SmartAgri
	CREATE
	DONE
### Buoc 7. Click OAuth2.0 Client IDs
	Download dinh dang json file
		HOAC
	Copy truc tiep: Client key
	Copy truc tiep: Client secrete
### Buoc 8. OAuth content screen
	Click PUBLISH App
		CONFIRM
### Buoc 9. Mo R len va test
library(gmailr)
gm_auth_configure(key="240677638712-a70r8lng6o91j48meb5ce4nj7ol2em65.apps.googleusercontent.com",secret = "1ndfdcQ3PDSkZNhDFsBR0_CN")
email <- gm_mime() %>%
    gm_to("thinhdv@ntu.edu.vn") %>%
    gm_from("itspider2019@gmail.com") %>%
    gm_subject("Test email subject thu 1") %>%
    gm_text_body("Test email body thu 1")

gm_send_message(email)

###### R se mo trinh duyet web yeu cau xac thuc:
	Mo chuc nang Advance va tien hanh CHO PHEP ung dung ben thu 3 mo gmail

### Buoc 10. Muon gui mail moi:
library(gmailr)
gm_auth_configure(key="240677638712-a70r8lng6o91j48meb5ce4nj7ol2em65.apps.googleusercontent.com",secret = "1ndfdcQ3PDSkZNhDFsBR0_CN")
email <- gm_mime() %>%
    gm_to("thinhdv@ntu.edu.vn") %>%
    gm_from("itspider2019@gmail.com") %>%
    gm_subject("Test email subject thu 2") %>%
    gm_text_body("Test email body thu 2")
#Attach file: gm_attach_file("AttachImage.png", id = "foobar")
gm_send_message(email)

## Muốn xác thực 1 lần duy nhất hãy tải file json và chỉ đường dẫn cho R
Authorise only one time?
library(gmailr)

gm_auth_configure(path  = "data/SendMailR.json")
options(
  gargle_oauth_cache = ".secret",
  gargle_oauth_email = "itspider2022@gmail.com"
)
gm_auth(email = "itspider2022@gmail.com")
