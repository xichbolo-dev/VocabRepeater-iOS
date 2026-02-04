Dưới đây là toàn bộ code hoàn chỉnh cho file ContentView.swift (SwiftUI app iOS), đã được cập nhật theo đúng ý bạn:
Có triển khai nút Day 1, Day 2..., mỗi ngày sẽ học 100 từ.
Chỉ có một nút lớn để bắt đầu luyện toàn bộ 100 từ.
Khi bấm nút → app tự động đọc lần lượt từng từ (Anh → Việt), không delay, đi hết 100 từ là xong 1 vòng, rồi quay lại từ đầu để làm tiếp vòng 2, ..., tổng cộng 9 vòng (tức là đọc toàn bộ danh sách 9 lần).
Highlight từ đang đọc.
Có nút Dừng.
App đọc liên tục không ngừng giữa tiếng anh và tiếng việt.
Danh sách từ vựng chỉ cách nhau bởi space (không xếp thành hàng dọc trong code và trong app, chỉ để dễ đọc). Danh sách từ vựng trên màn hình app cũng cách nhau bởi space thôi, không cần xếp thành 100 hàng, như vậy rất dài.
Thanh tua nhanh giờ là thanh điều chỉnh tốc độ đọc (giữa Normal 0.5-0.45 → Nhanh 1.25-1.0), đã được tách riêng thành một hàng riêng biệt ở dưới nút Dừng/Bắt đầu để tránh bị nhỏ.
Thanh slider tốc độ đã được tách riêng một hàng dưới nút Dừng/Bắt đầu, kích thước lớn hơn, dễ kéo.
Đọc Anh → Việt liên tục: utterance Việt được speak ngay sau Anh (không thêm delay giữa hai lệnh), engine sẽ đọc liền mạch.
Delay chỉ còn ở chuyển từ vựng tiếp theo (đã tối ưu để ngắn hơn khi tốc độ cao).
Mỗi ngày một mảng riêng (day1Vocabulary, day2Vocabulary, day3Vocabulary,...) → dễ thêm/sửa/xóa từ cho từng ngày mà không ảnh hưởng ngày khác.
Khi bạn có từ cho Day 4, Day 5,... chỉ cần thêm let day4Vocabulary: [VocabItem] = [...] và cập nhật switch selectedDay trong dailyVocabulary để thêm case tương ứng.
* Về delay sau mỗi từ:
Code đã giảm delay chuyển từ xuống mức thấp nhất (1.0s min, scale theo speed).
Nếu vẫn cảm thấy lớn → thử giảm max(1.0, ...) xuống max(0.5, ...) hoặc max(0.3, ...) (nhưng có thể gây overlap âm thanh nếu quá ngắn).
Test trên iPhone thật (không simulator) để có kết quả chính xác nhất.
*Cập nhật chính để fix highlight:
Chuyển danh sách từ trong ScrollView thành LazyVStack với ForEach riêng từng từ.
Mỗi từ giờ là một Text độc lập, highlight bằng màu đỏ + bold + background nhẹ khi currentIndex == index.
Highlight sẽ rõ ràng ngay cả khi đọc đến từ thứ 20, 50 hay 100 (vì mỗi từ có background và font weight riêng, dễ theo dõi khi scroll).
LazyVStack giúp chỉ load phần hiển thị, tránh lag khi danh sách dài.
Thêm thanh slider điều chỉnh font size (từ 18px đến 100px) ngay dưới thanh tốc độ đọc.
Font size áp dụng cho cả tiếng Anh và tiếng Việt trong danh sách.
Highlight vẫn hoạt động bình thường (màu đỏ + bold + nền nhẹ khi từ đang đọc).
Mỗi từ vựng giờ nằm trong một VStack riêng (tiếng Anh trên, tiếng Việt dưới), đảm bảo tiếng Việt luôn xuống hàng mới, không bị gãy dòng hay đẩy xuống dưới khi font to.
Font size slider (18–100px) áp dụng cho tiếng Anh, tiếng Việt hơi nhỏ hơn một chút (85%) để cân đối và đẹp hơn khi chữ rất to.
Highlight vẫn hoạt động hoàn hảo (màu đỏ + bold + nền nhẹ) trên cả hai dòng.
*Cập nhật mới nhất theo yêu cầu của bạn:
Màn hình tự động trượt (scroll) đến từ đang đọc (khi đọc đến từ thứ 10, 20, 50 hay 100 thì tự động kéo xuống để từ đó luôn nằm ở giữa màn hình, không cần dùng tay kéo nữa).
Sử dụng ScrollViewReader + ScrollViewProxy để scroll chính xác đến vị trí từ đang highlight.
Scroll chỉ diễn ra khi đang luyện, và chỉ khi từ mới được highlight.  
