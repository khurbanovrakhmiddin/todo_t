import 'dart:convert';
import '../../../domain/model/content_model.dart';

abstract class PlayerRemoteDataSource {
  Future<List<ContentModel>> getContents();

  Future<ContentModel> likeContent(int contentId);

  Future<ContentModel> dislikeContent(int contentId);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  List<ContentModel> _fakeContentData = [];

  Future<void> _loadFakeData() async {
    const String fakeJson = r'''
      [
        {
          "id": 1,
          "title": "20 век краткий пересказ",
          "description": "Список источников и литературы:\n1. Положение о социалистическом землеустройстве и о мерах перехода к социалистическому земледелию\n2. Трагедия советской деревни. Коллективизация и раскулачивание. 1927—1939. В 5 т. Т. 1. Май 1927 — ноябрь 1929\n3. Кондрашин В.В. Голод 1932-1933 годов. - М., РОССПЭН, 2008\n4. Поездка в Сибирь. Сталин. Жизнь одного вождя\n5. В.А.Ильиных Хроники хлебного фронта\n6. Дэвис Р.; Уиткрофт С. Годы голода: сельское хозяйство СССР, 1931–1933.\n7. Сталин И.В. Год великого перелома: К ХII годовщине Октября\n8. Фицпатрик Ш. Сталинские крестьяне.\n9. Постановление Совета Народных Комиссаров. О признаках кулацких хозяйств, в которых должен применяться кодекс законов о труде. 21 мая 1929 г\n10. Н.А.Ивницкий Судьба раскулаченных в СССР\n11. Зеленин И.Е. Сталинская революция сверху после великого перелома. 1930-1939. - М., Наука, 2006\n12. Докладная записка Секретно-политического отдела ОГПУ о формах и динамике классовой борьбы в деревне в 1930 г. 15 марта 1931 г. | Проект «Исторические Материалы»\n13. Закрытое письмо ЦК ВКП(б) от 2 апреля 1930 г. О задачах колхозного движения в связи с борьбой с искривлениями партийной линии. Приложение № 4 к п. 57 пр. ПБ № 122. | Проект «Исторические Материалы»\n14. Соцстроительство, 1934: Колхозы.\n15. Чуев Ф. Сто сорок бесед с Молотовым: Из дневника Ф. Чуева. Коллективизация\n16. Докладная записка Я.А. Яковлева в Политбюро ЦК ВКП(б) и СНК СССР об оплате работ МТС колхозами. 13 января 1933 г\n17. Экспорт зерновых начала 30-х гг. Хх В. В контексте голода 1932-1933 гг\n18. Шифротелеграмма первого секретаря Уральского обкома И.Д. Кабакова И.В. Сталину о недостатке хлеба для рабочего снабжения ; Внеочередное донесение Полномочного представительства ОГПУ по Западно-Сибирскому краю в Секретно-политический отдел ОГПУ СССР «О затруднениях в снабжении продовольствием городов и рабочих районов Западно-Сибирского края» на 30 июля 1931 г\n19. Шифротелеграмма секретарей ЦК ВКП(б) Л.М. Кагановича, П.П. Постышева, наркома снабжения СССР А.И. Микояна первому секретарю Нижне-Волжского крайкома ВКП(б) В.В. Птухе об отгрузке скота и мяса в Москву\n20. О снабжении и зарплате учительства\n21. Доклад секретаря обкома ВКП(б) Ивановской промышленной области И.П.Носова в связи с закрытым письмом ЦК ВКП(б) о забастовках рабочих в Вичугском, Лежневском, Пучежском и Тейковском районах. 20 апреля 1932 г. | Проект «Исторические Материалы»\n23. Постановление ЦИК и СНК СССР об охране имущества государственных предприятий 1932 г. | Музей истории российских реформ имени П. А. Столыпина\n24. «Гильотина Украины»: нарком Всеволод Балицкий и его судьба\n26. Постановление ЦК ВКП(б) и СНК СССР от 15.XII.1932 года. Об украинизации в ДВК, Казакстане, Средней Азии, ЦЧО и других районах СССР. Приложение № 10 к п. 50/22 пр. ПБ № 126. \n27. Сталин И.В. Письмо Л.М. Кагановичу и В.М. Молотову 18 июня 1932 года\n28. Трагедия советской деревни. Коллективизация и раскулачивание. 1927—1939. \n29. Киндлер Р. Сталинские кочевники: власть и голод в Казахстане.\n30. ГПИБ | № 28 : Статистические данные по выдаче ссуд на обсеменение и продовольствие населению, пострадавшему от неурожая в 1891-1892 гг. - 1894\n\nThe Closing - Hanna Ekstrom\nSummer Is Over - Fabien Tell\nAbsinthe-Minded - Damon Greene\nTrue Avidity - Brightarm Orchestra\nMythical Trees - DEX 1200\nEscalation - Jon Bjork\nWreck - Anna Dager\nCellar Stellar - Johnny Berglund\nWhere Are The Stars_ - Silver Maple\nUnderlying Cause - Experia\nUnder the Setting Sun - Million Eyes\nTvivel - Hanna Ekstrom\nFlute - Daniella Ljungsberg\nExit Fade - DEX 1200\nAlaskan Suite - Lennon Hutton\nBionic - Ethan Sloan\nAbsinthe-Minded - Damon Greene\nTvivel - Hanna Ekstrom\nCellar Stellar - Johnny Berglund\nIdentity Crisis - Edward Karl Hanson\nEthelda's Last Breath - Sage Oursler\nLost Glory (Instrumental Version) - Isaku Kageyama\nMargin - Daniella Ljungsberg\nWaltz of Winter - Anna Dager\nDescends to Rise - DEX 1200\nTvivel - Hanna Ekstrom\nWreck - Anna Dager\nMusic by Epidemic Sound",
          "url": "assets/src/video1.mp4",
          "like": 150,
          "disLike": 5
        },
        {
          "id": 2,
          "title": "Тест контент",
          "description": "Opisanie Chtoto kakoyto",
          "url": "https://live-hls-abr-cdn.livepush.io/live/bigbuckbunnyclip/index.m3u8",
          "like": 40,
          "disLike": 10
        }
      ]
    ''';

    final List<dynamic> jsonList = json.decode(fakeJson);
    _fakeContentData = jsonList
        .map((json) => ContentModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<ContentModel>> getContents() async {
    if (_fakeContentData.isEmpty) {
      await _loadFakeData();
    }
    await Future.delayed(const Duration(milliseconds: 500));

    return _fakeContentData;
  }

  @override
  Future<ContentModel> likeContent(int contentId) async {
    if (_fakeContentData.isEmpty) await _loadFakeData();

    await Future.delayed(const Duration(milliseconds: 300));

    final index = _fakeContentData.indexWhere((c) => c.id == contentId);
    if (index != -1) {
      final oldContent = _fakeContentData[index];
      final newContent = oldContent.copyWith(like: oldContent.like + 1);
      _fakeContentData[index] = newContent;
      return newContent;
    }
    throw Exception("Content with ID $contentId not found.");
  }

  @override
  Future<ContentModel> dislikeContent(int contentId) async {
    if (_fakeContentData.isEmpty) await _loadFakeData();

    await Future.delayed(const Duration(milliseconds: 300));

    final index = _fakeContentData.indexWhere((c) => c.id == contentId);
    if (index != -1) {
      final oldContent = _fakeContentData[index];
      final newContent = oldContent.copyWith(disLike: oldContent.disLike + 1);
      _fakeContentData[index] = newContent;
      return newContent;
    }
    throw Exception("Content with ID $contentId not found.");
  }
}
