# 같이갈개

## 작업내용
### 2021.12.22(수)
- 산책화면 구현 중 (polyLine 구현 필요)
- 산책화면 어느정도 구현완료 (산책시작 -> 실시간 위치변동 및 일시정지 -> 산책종료 -> 산책경로 저장)

## 화면구성
- 산책 페이지 : 지도에 현재위치 표시/산책시간 및 이동거리 기록/기록 종료시 이동한 발자취 이미지 등으로 저장
- 기록 페이지 : 산책 종료시 기록되는 정보를 저장하는 페이지. (리스트형태) 종료 후 사진 1장 남기기
- 플레이스 페이지 : 네이버 플레이스API 이용해서 주변 애견카페 등 지도로 표시해주기
- MY 페이지 : 반려견 정보 등록 (로컬DB)

## 사용 패키지
- google_maps_flutter: 구글 지도
-

## 로컬 데이터 저장 방식
- myPetNameList
    - MyPetModel (name, birth, weight, kind, sex, image)
    - MyPetModel (name, birth, weight, kind, sex, image)
    - MyPetModel (name, birth, weight, kind, sex, image)
    - ...
- currentIndex : 현재 포커싱되어 있는 반려견 인덱스

## 구글맵 거리 계산 로직
- 산책 시작버튼 클릭시 현재 위치가 시작/끝 위치가 됨
- 이동시 현재 위치는 시작위치, 새로운 위치가 끝위치가 됨
- 두 구간 사이에 polyLine 그리고, 두 구간 거리 계산하여 totalDistance에 저장
- 해당 작업을 산책 종료버튼 누르기 전까지 반복 수행

- 아 말은 쉽다..