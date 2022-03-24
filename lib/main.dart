import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_puzzle/sliding_puzzle_app.dart';

// Done elapsedTimer stream 초기 값을 00:00 으로 설정하기
// Done 조각 2개 이상을 한번에 이동시키기
// Done 조각 슬라이드 애니메이션에 커브 진행하기
// Done 게임 레이아웃 다시 잡기 (약 50% 진행)
// Done 움직인 횟수 구현
// Done 앱 색상테마 기본값 지정
// Done 경과시간을 나태내는 스트림빌더에서 발생하던 'Bad state: Stream has already been listened to' 오류 해결
//       => StreamController를 적정 시점에 재생성하는 방법 사용
// Done playing 상태에서만 슬라이딩이 가능하도록 제한
// Done 게임상태 세분화: 대기, 시작중, 게임중, 완성
// Done 게임 시작 시 3,2,1,Go 카운트 다운 구현
// Done 상단에 lottie 애니메이션 추가
// Done 이미지로 조각만들기
// Done (오류) completed 일 때 시간이 초기화됨
// Done 기본 기능 완료
// Done 가로 회전이 안되게 조치
// Done 디바이스 높이가 너무 낮은 경우 오류 아이콘 표시
// Done 5 x 5 일때 글자크기를 약간 작게
// Done 테마 선택 기능
// Done (Epic) 이미지 퍼즐 구현
// Done 이미지 로딩 속도를 올리기 위해 preview 이미지 사용
// Done 더 잘 어울리는 컬러 테마 적용
// Done (Epic) 게임 종료 후 share 기능 구현
// Done 중도 포기 시 경고화면 표시
// Done github 레포지토리 분리
// Done github pages에 배포
// Done (Epic) 사용자 앨범 이미지로 퍼즐 구현
// Done (Epic) 게임 레이아웃 다시 잡기
// Done   - 상태별 제어버튼 재구성 (대기, 시작중, 게임중, 완성)
// Done   - 반응형으로 레이아웃 구성
// Done (개선) 스와이프에도 조각이 움직이도록
// todo (기능) 미리보기 이미지를 오래 터치하면 완성 이미지 잠시 보여주기
// todo (기능) 사운드 추가
// todo 게임방법 소개 영상 링크: https://youtu.be/wD9sn5m5Evs?t=25
// todo (오류) 화면캡쳐 시 글자 색상 테마가 잘 적용되지 않음
// todo 게임방법 소개 (유튜브 링크)
// todo (기능) 게임 중 완성률을 계산하여 그래프로 표시 (고양이 대체)
// todo 파워포인트로 기획서 만들기
// todo   - 슬라이딩 규칙에 대한 자세한 설명 필요
// todo 게임 아이콘 만들기
// todo 게임 중지 시 alert dialog 띄우기
// todo (장기) riverpod로 교체

void main() {
  // 디바이스 세로 모드만 가능토록 지정
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // 앱 시작
  runApp(SlidingPuzzleApp());
}
