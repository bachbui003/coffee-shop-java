# Mộc Coffee — Java & PostgreSQL

Hai giao diện trong một ứng dụng:

- Khách hàng: `/coffee-shop/` — thực đơn, giỏ hàng, đặt món, mã xác nhận.
- Quản trị: `/coffee-shop/admin` — đăng nhập, quản lý đơn, thu tiền/hoàn tiền, doanh thu, thêm/sửa món và nhập tồn kho.

## Chạy ứng dụng

Yêu cầu Java 17 trở lên, Maven 3.9, Tomcat 9 và PostgreSQL 17. Không dùng Tomcat 10 vì ứng dụng dùng Servlet `javax`.

1. Tạo database PostgreSQL và một tài khoản sở hữu database.
2. Cấu hình các biến môi trường bên dưới cho tiến trình Tomcat.
3. Chạy `bash scripts/build.sh`.
4. Triển khai `target/coffee-shop.war` vào thư mục `webapps` của Tomcat, rồi khởi động Tomcat.
5. Kiểm tra `/coffee-shop/api/health` trả `status: ok` và `database: postgresql`.

Schema PostgreSQL trong `src/main/resources/schema.sql` được khởi tạo tự động theo giao dịch. Một thực đơn mẫu được tạo khi bảng sản phẩm trống. Các JSP và `sql_btl.sql` cũ được giữ để tham khảo lịch sử; bộ lọc chặn truy cập các trang cũ và WAR không đóng gói MySQL connector. Ứng dụng mới chỉ sử dụng PostgreSQL.

| Biến | Mục đích |
| --- | --- |
| `COFFEE_DB_URL` | JDBC URL PostgreSQL, ví dụ `jdbc:postgresql://127.0.0.1:5432/baitaplon` |
| `COFFEE_DB_USER` | Tài khoản PostgreSQL |
| `COFFEE_DB_PASSWORD` | Mật khẩu PostgreSQL; không lưu vào Git |
| `COFFEE_ADMIN_USER` | Tên đăng nhập quản trị |
| `COFFEE_COOKIE_SECURE` | Đặt `true` khi chạy sau HTTPS proxy; Dockerfile bật sẵn |
| `COFFEE_ADMIN_HASH` | Base64 salt + `:` + Base64 PBKDF2-HMAC-SHA256 hash, 260000 vòng, 256 bit |

Mật khẩu quản trị không được hard-code và không lưu trong database dạng rõ. Cấu hình thiếu làm ứng dụng khởi động thất bại.

## Môi trường cloud hiện tại

Checkout sử dụng nhánh `codex/cloud-environment-setup`; không sửa hay gộp vào `main`. Helper ngoài repository tại `/workspace/cloud-setup` cài dependencies, cấu hình HTTPS proxy cho Maven và khởi động PostgreSQL/Tomcat. Chạy `bash /workspace/cloud-setup/install.sh` rồi `bash /workspace/cloud-setup/start.sh`. Thông tin quản trị được lưu riêng trong file `/workspace/cloud-setup/admin-access.txt` với quyền `0600`. Không in mật khẩu ra log hoặc commit file này.

## Quy tắc đơn hàng và tiền

- Máy chủ tính giá từ database, không tin tổng tiền do trình duyệt gửi.
- Tồn kho trừ trong cùng giao dịch với tạo đơn. Khóa sản phẩm tránh bán vượt tồn kho; khóa theo mã yêu cầu tránh tạo trùng đơn khi gửi lại.
- Tiến độ: chờ xác nhận → xác nhận → chuẩn bị → hoàn tất. Đơn chỉ hoàn tất sau khi xác nhận đã thu tiền.
- Hủy đơn chưa hoàn tất sẽ nhập lại tồn kho đúng một lần. Đơn đã giao rồi hoàn tiền không nhập lại hàng.
- Tiền mặt và chuyển khoản được người quản trị xác nhận thủ công. Chọn chuyển khoản không tự ghi nhận tiền đã về; chưa tích hợp ngân hàng hay cổng thanh toán.
- Doanh thu là tổng tiền các đơn đang ở trạng thái đã thu tiền. Đơn hoàn tiền bị loại khỏi tổng. Thống kê ngày theo giờ Việt Nam và ngày đặt đơn.
- Thay đổi tồn kho kiểm tra giá trị trước khi sửa, tránh ghi đè hàng vừa được khách đặt.
- Quản trị dùng session, cookie HttpOnly/SameSite, CSRF token và giới hạn thử sai mật khẩu. Các endpoint chứa dữ liệu khách hàng yêu cầu đăng nhập.

## Kiểm tra

`tests/integration.py` kiểm tra HTTP và PostgreSQL thật: xác thực/CSRF, giá tính từ máy chủ, chống trùng đơn, hủy/nhập lại hàng, thu tiền/hoàn tiền, rollback khi đặt thất bại, cạnh tranh tồn kho, xung đột nhập hàng, ẩn sản phẩm và đăng xuất. Cấu hình các biến `COFFEE_TEST_*` ghi ở đầu file. Chỉ chạy trên môi trường phát triển; fixture được xóa qua PostgreSQL sau kiểm tra. `tests/browser.cjs` kiểm tra trình duyệt: thêm/nhập hàng, giỏ hàng, đặt món, thu tiền/hoàn tất, chống HTML injection trong ghi chú, responsive và đăng xuất. Trong cloud hiện tại, chạy `bash /workspace/cloud-setup/test.sh` để thực thi cả hai bộ kiểm tra.

Triển khai công khai cần một máy chủ hoặc dịch vụ hosting có HTTPS và PostgreSQL lưu trữ bền vững. Hai đường dẫn nêu trên dùng chung tên miền triển khai. Snapshot cloud lưu filesystem và cấu hình; các tiến trình cần khởi động lại, và snapshot không tự tạo một website công khai.

## Xuất bản website

Có sẵn `Dockerfile` triển khai WAR ở context gốc, nên hai đường dẫn sau khi hosting cấp tên miền sẽ là `/` và `/admin`. Container lắng nghe cổng 10000. `render.yaml` chuẩn bị web service và PostgreSQL trên Render; các giá trị bảo mật phải được cung cấp qua cấu hình dịch vụ. `COFFEE_DB_URL` phải là JDBC URL PostgreSQL của database đã tạo, dùng SSL phù hợp với hostname của nhà cung cấp. Không dùng tài khoản hay dữ liệu local cho database public.

Dockerfile/Render blueprint chưa được chạy tại hosting trong môi trường này. Gói miễn phí dành cho kiểm thử; PostgreSQL miễn phí của Render có hạn sử dụng, không phù hợp lưu đơn hàng lâu dài. Để kinh doanh thật, chọn database lưu trữ bền vững và sao lưu. Không có dịch vụ trả phí nào được tạo trong tác vụ này.

Quyền triển khai API Render có thể cấp bằng `RENDER_API_KEY` trong Environment settings. Không gửi key trong chat. Cấu hình môi trường cloud và xuất bản website là hai thao tác riêng: Publish snapshot không tự cấp URL website.
