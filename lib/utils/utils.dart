/// 미리보기용 이미지 파일 경로 반환
/// 원본 이미지 경로를 받아서 '-preview' postfix를 붙여 반환한다.
String getPreviewImagePath(String imagePath) {
  final tokens = imagePath.split(r'.');
  String previewImagePath = tokens[0];
  for (int i = 1; i < tokens.length; i++) {
    if (i < tokens.length - 1) {
      previewImagePath += '.' + tokens[i];
    } else {
      previewImagePath += '-preview.' + tokens[i];
    }
  }
  return previewImagePath;
}

void main() {
  print(getPreviewImagePath('assets/images/image3.png'));
  print(getPreviewImagePath('assets.images/image3.png'));
}
