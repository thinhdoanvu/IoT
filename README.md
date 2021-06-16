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

# DDNS của No-ip
## Bước 1. Đăng ký tên miền (free) từ No-ip
	login: no-ip.com
	tạo mới ddns: ntusmartagri.ddns.net
	xác thực bằng email đã đăng ký
Muốn đăng ký tên miền của cái nào thì tùy thuộc vào router hỗ trợ, như của mình thì hỗ trợ của No-ip, dyndns, DtDNS, VDDNS, dipic
Với 1 tài khoản free, tối đa được 3 domain
## Bước 2. Cấu hình modem để bên ngoài có thể truy cập
	Truy cập đến mục: DDNS
	Enable: DDNS
	Nhập tên server: https://my.noip.com
	username: itspider2022@gmail.com
	pasword:************************
	WAN Connection: ocmi_ip4_ppoe_1 (kiểu kết nối của cổng WAN, do mình cấu hình: ISP -> cắm vào cổng WAN thiết bị)
	Hostname: ntusmartagri.ddns.net
## Bước 3. Cấu hình chức năng Port Forwarding
	Enable chức năng
	Name: NTUSmartAgri (tên của trang web hay tên gì cũng được, vid dụ: port80_website1)
	WAN Host Start IP và End IP Address: Bỏ trống (vì mình không biết IP nào sẽ kết nối đến)
	WAN Connection: ocmi_ipv4_pppoe_1
	WAN Start Port: 80 (cổng cho phép từ Internet đi vào)
	WAN End Port: 80 (cổng cho phép từ Internet đi vào)
	*** 2 cái này có thể sửa là: 22- 3389 (ssh đến remote desktop)
	LAN Host IP Address: 192.168.1.3 (PC dùng làm web server)
	LAN Start Port: 80 (cổng cho phép từ mạng LAN kết nối vào webserver)
	LAN End Port: 80 (cổng cho phép từ mạng LAN kết nối vào webserver)
	*** 2 cái này có thể sửa là: 22- 3389 (ssh đến remote desktop)
## Bước 4. Kiểm tra cổng đã mở hay còn đóng
	https://www.portcheckers.com/
## Bước 5. Test thử mạng LAN
	Thay vì nhập: localhost/NTUSmartAgri
	Có thể: 192.168.1.3/NTUSmartAgri tử smart phone
## Bước 6. Test thử từ INTERNET
	http://ntusmartagri.ddns.net/NTUSmartAgri
	http://ntusmartagri.ddns.net/GeneticsConservation
	
