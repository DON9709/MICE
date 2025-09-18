# MICE

**MICE**는 문화 공간(박물관, 전시관 등)을 방문하며 스탬프를 수집할 수 있는 iOS 애플리케이션입니다.  
사용자는 위치 기반으로 현장에서만 스탬프를 획득할 수 있고, 찜하기/마이페이지/로그인 등 다양한 기능을 제공합니다.  

이 저장소는 App Store Connect에 등록된 **공식 Support URL**과 동일하게 사용됩니다.  
문의 및 지원이 필요하시면 이 문서를 참고해주세요.  

---

## 주요 기능 (Features)

- **회원 관리**
  - Apple 로그인 기반 회원가입/로그인
  - 마이페이지(프로필, 이메일 확인, 로그아웃, 회원 탈퇴)

- **스탬프 획득**
  - CoreLocation을 이용한 거리 기반 획득 로직
  - 박물관/전시관 등 특정 장소 400m 이내 접근 시 스탬프 획득 가능
  - 획득 시 방문 완료 라벨 및 획득 날짜 표시

- **즐겨찾기 관리**
  - 원하는 전시관/스탬프를 찜 목록에 추가/삭제
  - 별도 Bookmark 화면에서 확인 가능

---

## 🛠 기술 스택 (Tech Stack)

### iOS App
- **Language**: Swift 5.9+
- **UI Frameworks**: UIKit + SnapKit (부분 적용)
- **Reactivity**: Combine (데이터 바인딩)
- **System APIs**: CoreLocation (거리 기반 스탬프 획득)
- **Dependency Manager**: Swift Package Manager
- **Architecture**: MVVM (뷰모델 기반 상태 관리)

### Backend (Supabase)
- **Database**: PostgreSQL (Supabase Managed)
- **Auth**: Apple Sign-In + Supabase Auth (세션 기반 인증, RLS 정책)
- **Storage**: Supabase 테이블 (stamp, mystamp, wishlist, users)
- **Security**: Row Level Security (mystamp에 auth.uid() 자동 주입)

### Collaboration & Tools
- **Version Control**: GitHub
- **CI/CD**: Xcode Cloud (빌드/테스트), TestFlight (베타 배포)
- **Design**: Figma → SwiftUI/UIKit 반영
- **Project Management**: Notion, Slack

---

## 실행 방법 (Getting Started)

- **MICE 앱은 현재 TestFlight 베타 테스트를 통해 체험하실 수 있습니다.**: https://testflight.apple.com/join/BS79fxdx

---

## 지원 (Support)

- **문의**: 저장소 Issues 탭에 등록해주세요. 또는 TestFlight를 통한 이슈 리포트도 가능합니다.
- **이메일**: booby9709@gmail.com / gksmf0160@gmail.com / jesbio@naver.com

---

## 라이선스 (License)

MIT License

Copyright (c) 2025 [Myunggyun Song, Eunsae Jang, Ginam Kang, Donhyuk Lee]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
