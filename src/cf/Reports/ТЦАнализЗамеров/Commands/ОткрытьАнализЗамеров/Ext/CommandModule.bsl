﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиИспользуется = ТЦСервер.ОценкаПроизводительностиИспользуется();
	
	Если ОценкаПроизводительностиИспользуется Тогда
		ОткрытьФорму("Отчет.ТЦАнализЗамеров.Форма", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	Иначе
		Сообщить(НСтр("ru = 'Для использования отчета «Анализ замеров» необходимо встроить подсистему «Оценка производительности»'"));
	КонецЕсли;
	
КонецПроцедуры
