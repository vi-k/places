import '../../domain/sight.dart';

// Ресурсы

// BottomNavigator
const assetFavorite = 'res/favorite.svg';
const assetFavoriteFull = 'res/favorite_full.svg';
const assetList = 'res/list.svg';
const assetListFull = 'res/list_full.svg';
const assetMap = 'res/map.svg';
const assetMapFull = 'res/map_full.svg';
const assetSettings = 'res/settings.svg';
const assetSettingsFull = 'res/settings_full.svg';

// Buttons
const assetCalendar = 'res/calendar.svg';
const assetClose = 'res/close.svg';
const assetRoute = 'res/route.svg';
const assetShare = 'res/share.svg';
const assetPhoto = 'res/photo.svg';
const assetBack = 'res/back.svg';

const assetImage = 'res/image.svg';

// Категории
const assetCafe = 'res/cafe.svg';
const assetHotel = 'res/hotel.svg';
const assetMuseum = 'res/museum.svg';
const assetPark = 'res/park.svg';
const assetParticular = 'res/particular.svg';
const assetRestaurant = 'res/restaurant.svg';
String assetForSightType(SightType type) =>
    'res/${type.toString().replaceFirst(RegExp(r'.*\.'), '')}.svg';
const assetChoice = 'res/choice.svg';

// Тексты
const sightListScreenTitle = 'Список\nинтересных мест';
const sightDetailsScreenRoute = 'ПОСТРОИТЬ МАРШРУТ';
const sightDetailsScreenSchedule = 'Запланировать';
const sightDetailsScreenFavorite = 'В Избранное';

const visitingScreenTitle = 'Избранное';
const visitingScreenWishlist = 'Хочу посетить';
const visitingScreenVisited = 'Посещённые места';
const visitingScreenTabs = ['Хочу посетить', 'Посетил'];

const filtersTitle = 'Фильтр';
const filtersCategories = 'КАТЕГОРИИ';
const filtersDistance = 'Расстояние';
const filtersClear = 'Очистить';
const filtersApply = 'ПОКАЗАТЬ';

const settingsTitle = 'Настройки';
const settingsIsDark = 'Тёмная тема';
const settingsTutorial = 'Смотреть туториал';

const rangeFrom = 'от';
const rangeTo = 'до';
const meters = 'м';
const kilometers = 'км';
