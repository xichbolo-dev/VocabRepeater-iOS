import SwiftUI
import AVFoundation

struct VocabItem: Identifiable {
    let id = UUID()
    let english: String
    let vietnamese: String
}

struct ContentView: View {
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var currentIndex: Int? = nil
    @State private var currentWordIndex = 0
    @State private var currentRound = 0
    @State private var totalRounds = 9
    @State private var isPlaying = false
    @State private var selectedDay: Int = 1
    @State private var speechRate: Double = 0.5
    @State private var fontSize: Double = 40.0
    @State private var scrollProxy: ScrollViewProxy? = nil  // Để tự động scroll
    
    // Mảng từ vựng chia theo ngày riêng biệt
    let day1Vocabulary: [VocabItem] = [
        VocabItem(english: "abandon", vietnamese: "bỏ rơi"), VocabItem(english: "absorb", vietnamese: "hấp thụ"), VocabItem(english: "abstract", vietnamese: "trừu tượng"), VocabItem(english: "accent", vietnamese: "giọng địa phương"), VocabItem(english: "accommodate", vietnamese: "chứa đựng, điều chỉnh"), VocabItem(english: "accomplish", vietnamese: "hoàn thành"), VocabItem(english: "accountant", vietnamese: "kế toán viên"), VocabItem(english: "accuracy", vietnamese: "độ chính xác"), VocabItem(english: "accurate", vietnamese: "chính xác"), VocabItem(english: "acknowledge", vietnamese: "thừa nhận"), VocabItem(english: "acquire", vietnamese: "thu được"), VocabItem(english: "adapt", vietnamese: "thích nghi"), VocabItem(english: "addiction", vietnamese: "nghiện"), VocabItem(english: "adequate", vietnamese: "đủ, phù hợp"), VocabItem(english: "adjust", vietnamese: "điều chỉnh"), VocabItem(english: "affordable", vietnamese: "giá phải chăng"), VocabItem(english: "agency", vietnamese: "cơ quan"), VocabItem(english: "agenda", vietnamese: "chương trình nghị sự"), VocabItem(english: "aggressive", vietnamese: "hung hăng"), VocabItem(english: "aid", vietnamese: "hỗ trợ"), VocabItem(english: "alien", vietnamese: "người ngoài hành tinh / xa lạ"), VocabItem(english: "alter", vietnamese: "thay đổi"), VocabItem(english: "altogether", vietnamese: "hoàn toàn"), VocabItem(english: "ambulance", vietnamese: "xe cứu thương"), VocabItem(english: "amusing", vietnamese: "thú vị, hài hước"), VocabItem(english: "analyse", vietnamese: "phân tích"), VocabItem(english: "analysis", vietnamese: "sự phân tích"), VocabItem(english: "ancestor", vietnamese: "tổ tiên"), VocabItem(english: "anxiety", vietnamese: "lo lắng"), VocabItem(english: "anxious", vietnamese: "lo âu"), VocabItem(english: "apparent", vietnamese: "rõ ràng"), VocabItem(english: "appeal", vietnamese: "hấp dẫn / kháng cáo"), VocabItem(english: "approach", vietnamese: "cách tiếp cận"), VocabItem(english: "appropriate", vietnamese: "phù hợp"), VocabItem(english: "approve", vietnamese: "phê duyệt"), VocabItem(english: "arise", vietnamese: "phát sinh"), VocabItem(english: "artificial", vietnamese: "nhân tạo"), VocabItem(english: "aspect", vietnamese: "khía cạnh"), VocabItem(english: "assess", vietnamese: "đánh giá"), VocabItem(english: "asset", vietnamese: "tài sản"), VocabItem(english: "assume", vietnamese: "giả định"), VocabItem(english: "assure", vietnamese: "đảm bảo"), VocabItem(english: "astonishing", vietnamese: "đáng kinh ngạc"), VocabItem(english: "athletic", vietnamese: "thể thao"), VocabItem(english: "awkward", vietnamese: "lúng túng"), VocabItem(english: "bacteria", vietnamese: "vi khuẩn"), VocabItem(english: "balanced", vietnamese: "cân bằng"), VocabItem(english: "barely", vietnamese: "hầu như không"), VocabItem(english: "bargain", vietnamese: "mặc cả / món hời"), VocabItem(english: "barrier", vietnamese: "rào cản"), VocabItem(english: "basis", vietnamese: "cơ sở"), VocabItem(english: "beneficial", vietnamese: "có lợi"), VocabItem(english: "beyond", vietnamese: "vượt quá"), VocabItem(english: "bias", vietnamese: "thiên kiến"), VocabItem(english: "biological", vietnamese: "sinh học"), VocabItem(english: "bitter", vietnamese: "đắng / cay đắng"), VocabItem(english: "blame", vietnamese: "đổ lỗi"), VocabItem(english: "bold", vietnamese: "táo bạo"), VocabItem(english: "boost", vietnamese: "thúc đẩy"), VocabItem(english: "broad", vietnamese: "rộng"), VocabItem(english: "broadcast", vietnamese: "phát sóng"), VocabItem(english: "budget", vietnamese: "ngân sách"), VocabItem(english: "calculate", vietnamese: "tính toán"), VocabItem(english: "cancel", vietnamese: "hủy"), VocabItem(english: "capable", vietnamese: "có khả năng"), VocabItem(english: "capacity", vietnamese: "dung lượng / khả năng"), VocabItem(english: "capture", vietnamese: "bắt giữ / ghi lại"), VocabItem(english: "casual", vietnamese: "bình thường"), VocabItem(english: "certainty", vietnamese: "sự chắc chắn"), VocabItem(english: "challenging", vietnamese: "thử thách"), VocabItem(english: "characteristic", vietnamese: "đặc trưng"), VocabItem(english: "charming", vietnamese: "quyến rũ"), VocabItem(english: "circumstance", vietnamese: "hoàn cảnh"), VocabItem(english: "cite", vietnamese: "trích dẫn"), VocabItem(english: "civil", vietnamese: "dân sự"), VocabItem(english: "clarify", vietnamese: "làm rõ"), VocabItem(english: "classic", vietnamese: "cổ điển"), VocabItem(english: "classify", vietnamese: "phân loại"), VocabItem(english: "coincidence", vietnamese: "trùng hợp"), VocabItem(english: "collapse", vietnamese: "sụp đổ"), VocabItem(english: "combination", vietnamese: "sự kết hợp"), VocabItem(english: "commitment", vietnamese: "cam kết"), VocabItem(english: "commonly", vietnamese: "thường xuyên"), VocabItem(english: "comparative", vietnamese: "so sánh"), VocabItem(english: "complicated", vietnamese: "phức tạp"), VocabItem(english: "component", vietnamese: "thành phần"), VocabItem(english: "comprehensive", vietnamese: "toàn diện"), VocabItem(english: "compulsory", vietnamese: "bắt buộc"), VocabItem(english: "concentration", vietnamese: "sự tập trung"), VocabItem(english: "concept", vietnamese: "khái niệm"), VocabItem(english: "concern", vietnamese: "mối quan tâm"), VocabItem(english: "consequence", vietnamese: "hậu quả"), VocabItem(english: "conservative", vietnamese: "bảo thủ"), VocabItem(english: "considerable", vietnamese: "đáng kể"), VocabItem(english: "consistent", vietnamese: "nhất quán"), VocabItem(english: "constant", vietnamese: "liên tục"), VocabItem(english: "contemporary", vietnamese: "đương đại"), VocabItem(english: "controversial", vietnamese: "gây tranh cãi")
    ]
    
    let day2Vocabulary: [VocabItem] = [
        // Day 2 - bạn điền 100 từ tiếp theo vào đây
        VocabItem(english: "convince", vietnamese: "thuyết phục"), VocabItem(english: "cooperate", vietnamese: "hợp tác"), VocabItem(english: "corporation", vietnamese: "tập đoàn"), VocabItem(english: "creative", vietnamese: "sáng tạo"), VocabItem(english: "crisis", vietnamese: "khủng hoảng"), VocabItem(english: "criticize", vietnamese: "phê phán"), VocabItem(english: "crowded", vietnamese: "đông đúc"), VocabItem(english: "crucial", vietnamese: "quan trọng"), VocabItem(english: "culture", vietnamese: "văn hóa"), VocabItem(english: "curious", vietnamese: "tò mò"),
        // ... thêm đủ 100 từ cho Day 2
        VocabItem(english: "involve", vietnamese: "liên quan")
    ]
    
    let day3Vocabulary: [VocabItem] = [
        // Day 3 - bạn điền 100 từ tiếp theo vào đây
        VocabItem(english: "factor", vietnamese: "yếu tố"), VocabItem(english: "fail", vietnamese: "thất bại"), VocabItem(english: "fair", vietnamese: "công bằng"), VocabItem(english: "familiar", vietnamese: "quen thuộc"), VocabItem(english: "famous", vietnamese: "nổi tiếng"), VocabItem(english: "fashion", vietnamese: "thời trang"), VocabItem(english: "feature", vietnamese: "đặc điểm"), VocabItem(english: "federal", vietnamese: "liên bang"), VocabItem(english: "fee", vietnamese: "phí"), VocabItem(english: "feedback", vietnamese: "phản hồi"),
        // ... thêm đủ 100 từ cho Day 3
        VocabItem(english: "involve", vietnamese: "liên quan")
    ]
    
    var dailyVocabulary: [VocabItem] {
        switch selectedDay {
        case 1: return day1Vocabulary
        case 2: return day2Vocabulary
        case 3: return day3Vocabulary
        default: return day1Vocabulary
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Lưu ý: Để nghe nghĩa tiếng Việt rõ ràng (offline), vào Cài đặt > Trợ năng > Nội dung nói > Giọng nói > Tiếng Việt → Tải voice nếu chưa có.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(1...7, id: \.self) { day in
                            Button("Day \(day)") {
                                selectedDay = day
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(selectedDay == day ? .blue : .gray)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if isPlaying {
                    Text("Day \(selectedDay) - Vòng \(currentRound)/\(totalRounds) - Từ \(currentWordIndex + 1)/\(dailyVocabulary.count)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    if isPlaying {
                        synthesizer.stopSpeaking(at: .immediate)
                        isPlaying = false
                        currentIndex = nil
                        currentWordIndex = 0
                        currentRound = 0
                    } else {
                        startPractice()
                    }
                }) {
                    Text(isPlaying ? "Dừng luyện" : "Bắt đầu luyện 9 vòng")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Thanh tốc độ đọc
                if isPlaying {
                    VStack(spacing: 8) {
                        Text("Tốc độ đọc: \(String(format: "%.2f", speechRate))x")
                            .font(.caption)
                            .foregroundColor(.purple)
                        
                        Slider(value: $speechRate, in: 0.5...1.5, step: 0.05)
                            .accentColor(.purple)
                            .padding(.horizontal, 40)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    // Thanh font size
                    VStack(spacing: 8) {
                        Text("Kích thước chữ: \(Int(fontSize))px")
                            .font(.caption)
                            .foregroundColor(.orange)
                        
                        Slider(value: $fontSize, in: 18...100, step: 2)
                            .accentColor(.orange)
                            .padding(.horizontal, 40)
                    }
                    .padding(.horizontal)
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(dailyVocabulary.enumerated()), id: \.element.id) { index, item in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.english)
                                        .font(.system(size: fontSize))
                                        .fontWeight(currentIndex == index ? .black : .bold)
                                        .foregroundColor(currentIndex == index ? .red : .primary)
                                        .background(currentIndex == index ? Color.red.opacity(0.15) : Color.clear)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .cornerRadius(10)
                                        .id(index)  // ID để scroll đến
                                    
                                    Text(item.vietnamese)
                                        .font(.system(size: fontSize * 0.5))
                                        .foregroundColor(currentIndex == index ? .red.opacity(0.8) : .gray)
                                        .fontWeight(currentIndex == index ? .bold : .regular)
                                        .padding(.leading, 12)
                                }
                                .padding(.vertical, 6)
                                .onAppear {
                                    // Khi từ này xuất hiện trên màn hình, nếu đang highlight thì scroll đến giữa
                                    if currentIndex == index {
                                        withAnimation {
                                            proxy.scrollTo(index, anchor: .center)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity)
                    .onChange(of: currentIndex) { newIndex in
                        if let index = newIndex {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(index, anchor: .center)  // Tự động scroll đến từ đang đọc, nằm giữa màn hình
                            }
                        }
                    }
                }
                .navigationTitle("Luyện Từ Vựng Offline")
            }
        }
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio session error: \(error)")
            }
            
            _ = AVSpeechSynthesisVoice(language: "en-US")
            _ = AVSpeechSynthesisVoice(language: "vi-VN")
        }
        .onDisappear {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func startPractice() {
        synthesizer.stopSpeaking(at: .immediate)
        currentWordIndex = 0
        currentRound = 1
        isPlaying = true
        speakCurrentWord()
    }
    
    func speakCurrentWord() {
        if !isPlaying { return }
        
        let item = dailyVocabulary[currentWordIndex]
        currentIndex = currentWordIndex
        
        let currentRate = Float(speechRate)
        
        let enUtterance = AVSpeechUtterance(string: item.english)
        enUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        enUtterance.rate = currentRate
        enUtterance.postUtteranceDelay = 0.0
        synthesizer.speak(enUtterance)
        
        let viUtterance = AVSpeechUtterance(string: item.vietnamese)
        viUtterance.voice = AVSpeechSynthesisVoice(language: "vi-VN")
        viUtterance.rate = currentRate
        viUtterance.postUtteranceDelay = 0.0
        synthesizer.speak(viUtterance)
        
        let delayTime = max(1.0, 2.0 / speechRate)
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            if !self.isPlaying { return }
            
            self.currentWordIndex += 1
            
            if self.currentWordIndex >= self.dailyVocabulary.count {
                self.currentWordIndex = 0
                self.currentRound += 1
                
                if self.currentRound > self.totalRounds {
                    self.isPlaying = false
                    self.currentIndex = nil
                    self.currentRound = 0
                    return
                }
            }
            
            self.speakCurrentWord()
        }
    }
}

#Preview {
    ContentView()
}
