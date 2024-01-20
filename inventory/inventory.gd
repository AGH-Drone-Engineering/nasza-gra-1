extends Resource

class_name  Inv

signal update

@export var slots: Array[InvSlot]

var MAX_ITEMS_IN_SLOT = 10

func insert(item: InvItem):
	pass
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty() and item_slots[0].amount < MAX_ITEMS_IN_SLOT:
		item_slots[0].amount += 1		
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	update.emit()
	
func delete(name: String):
	for slot in slots:
		if slot.item != null and slot.item.name == name:
			if slot.amount > 1:
				slot.amount -= 1
			else:
				slot.item = null
				slot.amount = 0
			update.emit()
			return  # Stop searching after deleting the item
