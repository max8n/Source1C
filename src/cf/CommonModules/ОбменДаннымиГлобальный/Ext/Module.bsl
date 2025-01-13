﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет проверку необходимости обновления конфигурации базы данных в подчиненном узле.
//
Процедура ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзла() Экспорт
	
	ТребуетсяОбновление = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ТребуетсяОбновлениеКонфигурацииУзлаРИБ;
	ПроверитьНеобходимостьОбновления(ТребуетсяОбновление);
	
КонецПроцедуры

// Выполняет проверку необходимости обновления конфигурации базы данных в подчиненном узле при запуске.
//
Процедура ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзлаПриЗапуске() Экспорт
	
	ТребуетсяОбновление = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().ТребуетсяОбновлениеКонфигурацииУзлаРИБ;
	ПроверитьНеобходимостьОбновления(ТребуетсяОбновление);
	
КонецПроцедуры

Процедура ПроверитьНеобходимостьОбновления(ТребуетсяОбновлениеКонфигурацииУзлаРИБ)
	
	Если ТребуетсяОбновлениеКонфигурацииУзлаРИБ Тогда
		Пояснение = НСтр("ru = 'Получено обновление программы из ""%1"".
			|Установите обновление программы, после чего синхронизация данных будет продолжена.'");
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Пояснение, СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ГлавныйУзел);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Установить обновление'"), "e1cib/app/Обработка.ВыполнениеОбменаДанными",
			Пояснение, БиблиотекаКартинок.Предупреждение32);
		Оповестить("ВыполненОбменДанными");
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьНеобходимостьОбновленияКонфигурацииПодчиненногоУзла", 60 * 60, Истина); // раз в час
	
КонецПроцедуры

#КонецОбласти
