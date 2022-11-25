enum V2TimImageTypesEnum {
  original,
  big,
  small,
}

class HistoryMessageDartConstant {
  static const getCount = 20;

  // ignore: constant_identifier_names
  static const V2_TIM_IMAGE_TYPES = {
    'ORIGINAL': 0,
    'BIG': 1,
    'SMALL': 2,
  };

  static Map<V2TimImageTypesEnum, List<String>> imgPriorMap = {
    V2TimImageTypesEnum.original: oriImgPrior,
    V2TimImageTypesEnum.big: bigImgPrior,
    V2TimImageTypesEnum.small: smallImgPrior,
  };

  // 缩略图优先，大图次之，最后是原图
  static const smallImgPrior = ['ORIGINAL', 'BIG', 'SMALL'];
  // 大图优先，原图次之，最后是缩略图
  static const bigImgPrior = ['SMALL', 'ORIGINAL', 'BIG'];
  // 原图优先，大图次之，最后是缩略图
  static const oriImgPrior = ['SMALL', 'BIG', 'ORIGINAL'];

  // 视频、音频已读状态
  static const int read = 1;
}
