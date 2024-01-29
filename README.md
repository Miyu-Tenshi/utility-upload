# Utility upload everywhere

### Syntax

-   USERNAME : ระบุชื่อ Github
-   EMAIL : ระบุเมลล์ Github
-   BRANCH : ระบุ branch
-   REPO : ระบุชื่อ repository
-   MESSAGE : กำหนด ข้อความ commit ต้องมีสัญลักษณ์ "" หรือ ฟันหนูคลุมข้อความเสมอในกรณีที่ต้องการใช้ข้อความเว้นวรรค เช่น "new update foo bar"
-   init : กำหนด init ทุกครั้งที่มีการเรื่มโปรเจคครั้งแรกหรือมีการเปลี่ยน Branch หรือ Repo (เป็น Optional ในครั้งต่อไปที่ upload ขึ้น Github)

```bash
eval "`curl -sL https://himei.city/scripts/git-push`";upload USERNAME EMAIL BRANCH REPO "MESSAGE" init
```

### Example

เมื่ออัพโหลด code ครั้งแรก หรือมีการเปลี่ยน branch หรือ repository

```bash
eval "`curl -sL https://himei.city/scripts/git-push`";upload himei-miyu example@gmail.com main utility-upload "comment" init
```

อัพโหลดครั้งต่อไป ไม่จำเป็นต้องใส่ init ต่อท้าย

```bash
eval "`curl -sL https://himei.city/scripts/git-push`";upload himei-miyu example@gmail.com main utility-upload "comment"
```
