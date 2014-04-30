-- spec file for solution to poker hands CodeEval problem

require("busted");

describe("Test Hand clasifications", function()
	it("is high card", function() 
		assert.same(hand.new("2S 4D 7C TS JH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches=false, highCard={11, 10, 7, 4, 2}}));
		assert.same(hand.new("2S 4D 7C TS 3H"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches=false, highCard={10, 7, 4, 3, 2}}));
	end)
	it("is one pair", function()
		assert.same(hand.new("2S 2D 7C TS JH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(2,2)}, highCard={11, 10, 7, 2, 2}}));
		assert.same(hand.new("QS 2D 7C TS QH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(2,12)}, highCard={12, 12, 10, 7, 2}}));
	end)
	it("is two pair", function()
		assert.same(hand.new("2S 2D 7C 7S JH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(2,7), new_match(2,2)}, highCard={11, 7, 7, 2, 2}}));
		assert.same(hand.new("QS 2D 7C 7S QH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(2,12), new_match(2,7)}, highCard={12, 12, 7, 7, 2}}));
	end)
	it("is three of a kind", function()
		assert.same(hand.new("2S 2D 2C TS JH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(3,2)}, highCard={11, 10, 2, 2, 2}}));
		assert.same(hand.new("QS 2D QC TS QH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(3,12)}, highCard={12, 12, 12, 10, 2}}));
	end)
	it("is straight", function()
		assert.same(hand.new("2S 3D 4C 5S 6H"):get_value(), hand.value.new({isFlush=false, isStriaght=6, matches=false, highCard={6, 5, 4, 3, 2}}));
		assert.same(hand.new("JS QD KC AS TH"):get_value(), hand.value.new({isFlush=false, isStriaght=14, matches=false, highCard={14, 13, 12, 11, 10}}));
	end)
	it("is flush", function()
		assert.same(hand.new("2S 3S 7S TS JS"):get_value(), hand.value.new({isFlush=11, isStriaght=false, matches=false, highCard={11, 10, 7, 3, 2}}));
		assert.same(hand.new("QH 2H 7H TH QH"):get_value(), hand.value.new({isFlush=12, isStriaght=false, matches={new_match(2,12)}, highCard={12, 12, 10, 7, 2}}));
	end)
	it("is full house", function()
		assert.same(hand.new("2S 2D 2C TS TH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(3,2), new_match(2,10)}, highCard={10, 10, 2, 2, 2}}));
		assert.same(hand.new("QS 2D QC 2S QH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_matcy(3,12),new_match(2,22)}, highCard={12, 12, 12, 2, 2}}));
	end)
	it("is four of a kind", function()
		assert.same(hand.new("2S 2D 2C 2S JH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(4,2)}, highCard={11, 2, 2, 2, 2}}));
		assert.same(hand.new("QS 2D QC QS QH"):get_value(), hand.value.new({isFlush=false, isStriaght=false, matches={new_match(4,12)}, highCard={12, 12, 12, 12, 2}}));
	end)
	it("is straight flush", function()
		assert.same(hand.new("2S 3S 4S 5S 6S"):get_value(), hand.value.new({isFlush=6, isStriaght=6, matches=false, highCard={6, 5, 4, 3, 2}}));
		assert.same(hand.new("QH JH TH KH AH"):get_value(), hand.value.new({isFlush=14, isStriaght=14, matches=false, highCard={14, 13, 12, 11, 10}}));
	end)
end)
	
describe("Test hand rankings", function()
	local royalFlush, straightFlush, fourOf, fullHouse, flush, straight, threeOf, twoPair, onePair, highCard, lowCard;
	(function()
		royalFlush=hand.new("QH JH TH KH AH"):get_value();
		straightFlush=hand.new("2S 3S 4S 5S 6S"):get_value();
		fourOf=hand.new("2S 2D 2C 2S JH"):get_value();
		fullHouse=hand.new("2S 2D 2C TS TH"):get_value();
		flush=hand.new("2S 3S 7S TS JS"):get_value();
		straight=hand.new("2S 3D 4C 5S 6H"):get_value();
		threeOf=hand.new("2S 2D 2C TS JH"):get_value();
		twoPair=hand.new("2S 2D 7C 7S JH"):get_value();
		onePair=hand.new("QS 2D 7C TS QH"):get_value();
		highCard=hand.new("2S 4D 7C TS JH"):get_value();
		lowCard=hand.new("2S 4D 7C TS 3H"):get_value();
	end)
	
	it("royal flush beats all", function()
		assert.is_not_true(royalFlush > royalFlush);
		assert.is_true(royalFlush > straightFlush);
		assert.is_true(royalFlush > fourOf);
		assert.is_true(royalFlush > fullHouse);
		assert.is_true(royalFlush > flush);
		assert.is_true(royalFlush > straight);
		assert.is_true(royalFlush > threeOf);
		assert.is_true(royalFlush > twoPair);
		assert.is_true(royalFlush > onePair);
		assert.is_true(royalFlush > highCard);
		assert.is_true(royalFlush > lowCard);
	end)
	it("straight flush beats four of a kind", function()
		assert.is_not_true(straightFlush > royalFlush);
		assert.is_not_true(straightFlush > straightFlush);
		assert.is_true(straightFlush > fourOf);
		assert.is_true(straightFlush > fullHouse);
		assert.is_true(straightFlush > flush);
		assert.is_true(straightFlush > straight);
		assert.is_true(straightFlush > threeOf);
		assert.is_true(straightFlush > twoPair);
		assert.is_true(straightFlush > onePair);
		assert.is_true(straightFlush > highCard);
		assert.is_true(straightFlush > lowCard);
	end)
	it("four of a kind beats full house", function()
		assert.is_not_true(fourOf > royalFlush);
		assert.is_not_true(fourOf > straightFlush);
		assert.is_not_true(fourOf > fourOf);
		assert.is_true(fourOf > fullHouse);
		assert.is_true(fourOf > flush);
		assert.is_true(fourOf > straight);
		assert.is_true(fourOf > threeOf);
		assert.is_true(fourOf > twoPair);
		assert.is_true(fourOf > onePair);
		assert.is_true(fourOf > highCard);
		assert.is_true(fourOf > lowCard);
	end)
	it("full house beats flush", function()
		assert.is_not_true(fullHouse > royalFlush);
		assert.is_not_true(fullHouse > straightFlush);
		assert.is_not_true(fullHouse > fourOf);
		assert.is_not_true(fullHouse > fullHouse);
		assert.is_true(fullHouse > flush);
		assert.is_true(fullHouse > straight);
		assert.is_true(fullHouse > threeOf);
		assert.is_true(fullHouse > twoPair);
		assert.is_true(fullHouse > onePair);
		assert.is_true(fullHouse > highCard);
		assert.is_true(fullHouse > lowCard);
	end)
	it("flush beats straight", function()
		assert.is_not_true(flush > royalFlush);
		assert.is_not_true(flush > straightFlush);
		assert.is_not_true(flush > fourOf);
		assert.is_not_true(flush > fullHouse);
		assert.is_not_true(flush > flush);
		assert.is_true(flush > straight);
		assert.is_true(flush > threeOf);
		assert.is_true(flush > twoPair);
		assert.is_true(flush > onePair);
		assert.is_true(flush > highCard);
		assert.is_true(flush > lowCard);
	end)
	it("straight beats three of a kind", function()
		assert.is_not_true(straight > royalFlush);
		assert.is_not_true(straight > straightFlush);
		assert.is_not_true(straight > fourOf);
		assert.is_not_true(straight > fullHouse);
		assert.is_not_true(straight > flush);
		assert.is_not_true(straight > straight);
		assert.is_true(straight > threeOf);
		assert.is_true(straight > twoPair);
		assert.is_true(straight > onePair);
		assert.is_true(straight > highCard);
		assert.is_true(straight > lowCard);
	end)
	it("three of a kind beats two pair", function()
		assert.is_not_true(threeOf > royalFlush);
		assert.is_not_true(threeOf > straightFlush);
		assert.is_not_true(threeOf > fourOf);
		assert.is_not_true(threeOf > fullHouse);
		assert.is_not_true(threeOf > flush);
		assert.is_not_true(threeOf > straight);
		assert.is_not_true(threeOf > threeOf);
		assert.is_true(threeOf > twoPair);
		assert.is_true(threeOf > onePair);
		assert.is_true(threeOf > highCard);
		assert.is_true(threeOf > lowCard);
	end)
	it("two pair beats one pair", function()
		assert.is_not_true(twoPair > royalFlush);
		assert.is_not_true(twoPair > straightFlush);
		assert.is_not_true(twoPair > fourOf);
		assert.is_not_true(twoPair > fullHouse);
		assert.is_not_true(twoPair > flush);
		assert.is_not_true(twoPair > straight);
		assert.is_not_true(twoPair > threeOf);
		assert.is_not_true(twoPair > twoPair);
		assert.is_true(twoPair > onePair);
		assert.is_true(twoPair > highCard);
		assert.is_true(twoPair > lowCard);
	end)
	it("one pair beats high card", function()
		assert.is_not_true(onePair > royalFlush);
		assert.is_not_true(onePair > straightFlush);
		assert.is_not_true(onePair > fourOf);
		assert.is_not_true(onePair > fullHouse);
		assert.is_not_true(onePair > flush);
		assert.is_not_true(onePair > straight);
		assert.is_not_true(onePair > threeOf);
		assert.is_not_true(onePair > twoPair);
		assert.is_not_true(onePair > onePair);
		assert.is_true(onePair > highCard);
		assert.is_true(onePair > lowCard);
	end)
	it("high card beats low card", function()
		assert.is_not_true(highCard > royalFlush);
		assert.is_not_true(highCard > straightFlush);
		assert.is_not_true(highCard > fourOf);
		assert.is_not_true(highCard > fullHouse);
		assert.is_not_true(highCard > flush);
		assert.is_not_true(highCard > straight);
		assert.is_not_true(highCard > threeOf);
		assert.is_not_true(highCard > twoPair);
		assert.is_not_true(highCard > onePair);
		assert.is_not_true(highCard > highCard);
		assert.is_true(highCard > lowCard);
	end)
end)