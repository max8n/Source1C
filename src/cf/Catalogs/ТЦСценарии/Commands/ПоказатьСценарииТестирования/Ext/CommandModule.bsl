﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТЦСервер.ТестВыполняется() Тогда
		ТЦКлиент.ПоказатьСостояниеТестирования();
	Иначе
		ТЦКлиент.ВыполнитьТестирование();
	КонецЕсли;
	
КонецПроцедуры
