require("busted");

describe("hand should exist", function()
	setup(function()
		debugFlag = true;
		loadfile("PokerHands.lua")();
	end)
	
	it("deck does exist", function()
		assert.not_nil(deck);
		end)
	it("hand does exist", function()
		assert.not_nil(hand)
	end)
	describe("Test Hand clasifications #classify", function()
		it("is high card", function() 
			assert.same(hand.new("2S 4D 7C TS JH"):get_value(), {isFlush=false, isStraight=false, matches=false, highCard={11, 10, 7, 4, 2}});
			assert.same(hand.new("2S 4D 7C TS 3H"):get_value(), {isFlush=false, isStraight=false, matches=false, highCard={10, 7, 4, 3, 2}});
		end)
		it("is one pair", function()
			assert.same(hand.new("2S 2D 7C TS JH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(2,2)}, highCard={11, 10, 7, 2, 2}});
			assert.same(hand.new("QS 2D 7C TS QH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(2,12)}, highCard={12, 12, 10, 7, 2}});
		end)
		it("is two pair", function()
			assert.same(hand.new("2S 2D 7C 7S JH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(2,7), hand.new_match(2,2)}, highCard={11, 7, 7, 2, 2}});
			assert.same(hand.new("QS 2D 7C 7S QH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(2,12), hand.new_match(2,7)}, highCard={12, 12, 7, 7, 2}});
		end)
		it("is three of a kind", function()
			assert.same(hand.new("2S 2D 2C TS JH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(3,2)}, highCard={11, 10, 2, 2, 2}});
			assert.same(hand.new("QS 2D QC TS QH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(3,12)}, highCard={12, 12, 12, 10, 2}});
		end)
		it("is straight", function()
			assert.same(hand.new("2S 3D 4C 5S 6H"):get_value(), {isFlush=false, isStraight=6, matches=false, highCard={6, 5, 4, 3, 2}});
			assert.same(hand.new("JS QD KC AS TH"):get_value(), {isFlush=false, isStraight=14, matches=false, highCard={14, 13, 12, 11, 10}});
		end)
		it("is flush", function()
			assert.same(hand.new("2S 3S 7S TS JS"):get_value(), {isFlush=11, isStraight=false, matches=false, highCard={11, 10, 7, 3, 2}});
			assert.same(hand.new("QH 2H 7H TH QH"):get_value(), {isFlush=12, isStraight=false, matches={hand.new_match(2,12)}, highCard={12, 12, 10, 7, 2}});
		end)
		it("is full house", function()
			assert.same(hand.new("2S 2D 2C TS TH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(3,2), hand.new_match(2,10)}, highCard={10, 10, 2, 2, 2}});
			assert.same(hand.new("QS 2D QC 2S QH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(3,12),hand.new_match(2,2)}, highCard={12, 12, 12, 2, 2}});
		end)
		it("is four of a kind", function()
			assert.same(hand.new("2S 2D 2C 2S JH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(4,2)}, highCard={11, 2, 2, 2, 2}});
			assert.same(hand.new("QS 2D QC QS QH"):get_value(), {isFlush=false, isStraight=false, matches={hand.new_match(4,12)}, highCard={12, 12, 12, 12, 2}});
		end)
		it("is straight flush", function()
			assert.same(hand.new("2S 3S 4S 5S 6S"):get_value(), {isFlush=6, isStraight=6, matches=false, highCard={6, 5, 4, 3, 2}});
			assert.same(hand.new("QH JH TH KH AH"):get_value(), {isFlush=14, isStraight=14, matches=false, highCard={14, 13, 12, 11, 10}});
			assert.same(hand.new("TH JH QH KH AH"):get_value(), {isFlush=14, isStraight=14, matches=false, highCard={14, 13, 12, 11, 10}});
			assert.same(hand.new("2D 3D 4D 5D 6D"):get_value(), {isFlush=6, isStraight=6, matches=false, highCard={6, 5, 4, 3, 2}});
		end)
	end)
	
	describe("Test hand rankings #compare", function()
		setup(function()
			royalFlush = hand.new("TH JH QH KH AH"):get_value();
			straightFlush = hand.new("2D 3D 4D 5D 6D"):get_value();
			fourOf = hand.new("QS 2D QC QS QH"):get_value();
			fullHouse = hand.new("QS 2D QC 2S QH"):get_value();
			flush = hand.new("QH 2H 7H TH QH"):get_value();
			straight = hand.new("JS QD KC AS TH"):get_value();
			threeOf = hand.new("QS 2D QC TS QH"):get_value();
			twoPair = hand.new("QS 2D 7C 7S QH"):get_value();
			onePair = hand.new("QS 2D 7C TS QH"):get_value();
			highCard = hand.new("2S 4D 7C TS 3H"):get_value();
		end)
		-- Royal Flush
		it("royal flush beats straight flush", function()
			assert.is_true(hand.compare(royalFlush, straightFlush));
			assert.is_false(hand.compare(straightFlush, royalFlush));
		end)
		it("royal flush beats 4 of a kind", function()
			assert.is_true(hand.compare(royalFlush, fourOf));
			assert.is_false(hand.compare(fourOf, royalFlush));
		end)
		it("royal flush beats full house", function()
			assert.is_true(hand.compare(royalFlush, fullHouse));
			assert.is_false(hand.compare(fullHouse, royalFlush));
		end)
		it("royal flush beats flush", function()
			assert.is_true(hand.compare(royalFlush, flush));
			assert.is_false(hand.compare(flush, royalFlush));
		end)
		it("royal flush beats straight", function()
			assert.is_true(hand.compare(royalFlush, straight));
			assert.is_false(hand.compare(straight, royalFlush));
		end)
		it("royal flush beats 3 of a kind", function()
			assert.is_true(hand.compare(royalFlush, threeOf));
			assert.is_false(hand.compare(threeOf, royalFlush));
		end)
		it("royal flush beats 2 pair", function()
			assert.is_true(hand.compare(royalFlush, twoPair));
			assert.is_false(hand.compare(twoPair, royalFlush));
		end)
		it("royal flush beats pair", function()
			assert.is_true(hand.compare(royalFlush, onePair));
			assert.is_false(hand.compare(onePair, royalFlush));
		end)
		it("royal flush beats high card", function()
			assert.is_true(hand.compare(royalFlush, highCard));
			assert.is_false(hand.compare(highCard, royalFlush));
		end)
		-- Straight Flush
		it("straight flush beats 4 of a kind", function()
			assert.is_true(hand.compare(straightFlush, fourOf));
			assert.is_false(hand.compare(fourOf, straightFlush));
		end)
		it("straight flush beats full house", function()
			assert.is_true(hand.compare(straightFlush, fullHouse));
			assert.is_false(hand.compare(fullHouse, straightFlush));
		end)
		it("straight flush beats flush", function()
			assert.is_true(hand.compare(straightFlush, flush));
			assert.is_false(hand.compare(flush, straightFlush));
		end)
		it("straight flush beats straight", function()
			assert.is_true(hand.compare(straightFlush, straight));
			assert.is_false(hand.compare(straight, straightFlush));
		end)
		it("straight flush beats 3 of a kind", function()
			assert.is_true(hand.compare(straightFlush, threeOf));
			assert.is_false(hand.compare(threeOf, straightFlush));
		end)
		it("straight flush beats 2 pair", function()
			assert.is_true(hand.compare(straightFlush, twoPair));
			assert.is_false(hand.compare(twoPair, straightFlush));
		end)
		it("straight flush beats pair", function()
			assert.is_true(hand.compare(straightFlush, onePair));
			assert.is_false(hand.compare(onePair, straightFlush));
		end)
		it("straight flush beats high card", function()
			assert.is_true(hand.compare(straightFlush, highCard));
			assert.is_false(hand.compare(highCard, straightFlush));
		end)
		-- four of a kind
		it("4 of a kind beats full house", function()
			assert.is_true(hand.compare(fourOf, fullHouse));
			assert.is_false(hand.compare(fullHouse, fourOf));
		end)
		it("4 of a kind beats flush", function()
			assert.is_true(hand.compare(fourOf, flush));
			assert.is_false(hand.compare(flush, fourOf));
		end)
		it("4 of a kind beats straight", function()
			assert.is_true(hand.compare(fourOf, straight));
			assert.is_false(hand.compare(straight, fourOf));
		end)
		it("4 of a kind beats 3 of a kind", function()
			assert.is_true(hand.compare(fourOf, threeOf));
			assert.is_false(hand.compare(threeOf, fourOf));
		end)
		it("4 of a kind beats 2 pair", function()
			assert.is_true(hand.compare(fourOf, twoPair));
			assert.is_false(hand.compare(twoPair, fourOf));
		end)
		it("4 of a kind beats pair", function()
			assert.is_true(hand.compare(fourOf, onePair));
			assert.is_false(hand.compare(onePair, fourOf));
		end)
		it("4 of a kind beats high card", function()
			assert.is_true(hand.compare(fourOf, highCard));
			assert.is_false(hand.compare(highCard, fourOf));
		end)
		-- full house
		it("full house beats flush", function()
			assert.is_true(hand.compare(fullHouse, flush));
			assert.is_false(hand.compare(flush, fullHouse));
		end)
		it("full house beats straight", function()
			assert.is_true(hand.compare(fullHouse, straight));
			assert.is_false(hand.compare(straight, fullHouse));
		end)
		it("full house beats 3 of a kind", function()
			assert.is_true(hand.compare(fullHouse, threeOf));
			assert.is_false(hand.compare(threeOf, fullHouse));
		end)
		it("full house beats 2 pair", function()
			assert.is_true(hand.compare(fullHouse, twoPair));
			assert.is_false(hand.compare(twoPair, fullHouse));
		end)
		it("full house beats pair", function()
			assert.is_true(hand.compare(fullHouse, onePair));
			assert.is_false(hand.compare(onePair, fullHouse));
		end)
		it("full house beats high card", function()
			assert.is_true(hand.compare(fullHouse, highCard));
			assert.is_false(hand.compare(highCard, fullHouse));
		end)
		-- flush
		it("flush beats straight", function()
			assert.is_true(hand.compare(flush, straight));
			assert.is_false(hand.compare(straight, flush));
		end)
		it("flush beats 3 of a kind", function()
			assert.is_true(hand.compare(flush, threeOf));
			assert.is_false(hand.compare(threeOf, flush));
		end)
		it("flush beats 2 pair", function()
			assert.is_true(hand.compare(flush, twoPair));
			assert.is_false(hand.compare(twoPair, flush));
		end)
		it("flush beats pair", function()
			assert.is_true(hand.compare(flush, onePair));
			assert.is_false(hand.compare(onePair, flush));
		end)
		it("flush beats high card", function()
			assert.is_true(hand.compare(flush, highCard));
			assert.is_false(hand.compare(highCard, flush));
		end)
		-- straight
		it("straight beats 3 of a kind", function()
			assert.is_true(hand.compare(straight, threeOf));
			assert.is_false(hand.compare(threeOf, straight));
		end)
		it("straight beats 2 pair", function()
			assert.is_true(hand.compare(straight, twoPair));
			assert.is_false(hand.compare(twoPair, straight));
		end)
		it("straight beats pair", function()
			assert.is_true(hand.compare(straight, onePair));
			assert.is_false(hand.compare(onePair, straight));
		end)
		it("straight beats high card", function()
			assert.is_true(hand.compare(straight, highCard));
			assert.is_false(hand.compare(highCard, straight));
		end)
		-- 3 of a kind
		it("3 of a kind beats 2 pair", function()
			assert.is_true(hand.compare(threeOf, twoPair));
			assert.is_false(hand.compare(twoPair, threeOf));
		end)
		it("3 of a kind beats pair", function()
			assert.is_true(hand.compare(threeOf, onePair));
			assert.is_false(hand.compare(onePair, threeOf));
		end)
		it("3 of a kind beats high card", function()
			assert.is_true(hand.compare(threeOf, highCard));
			assert.is_false(hand.compare(highCard, threeOf));
		end)
		-- 2 pair
		it("2 pair beats pair", function()
			assert.is_true(hand.compare(twoPair, onePair));
			assert.is_false(hand.compare(onePair, twoPair));
		end)
		it("2 pair beats high card", function()
			assert.is_true(hand.compare(twoPair, highCard));
			assert.is_false(hand.compare(highCard, twoPair));
		end)
		it("2 pair with hogh card beats 2 Pair with low card card", function()
			assert.is_true(hand.compare(hand.new("AH AD JS JS 6S"):get_value(), hand.new("AS AC JH JH 3H"):get_value()));
		end)
		-- pair
		it("pair beats high card", function()
			assert.is_true(hand.compare(onePair, highCard));
		end)
		it("pair with hogh card beats Pair with low card card", function()
			assert.is_true(hand.compare(hand.new("AH AD 3S 5S 6S"):get_value(), hand.new("AS AC 4H 5H 3H"):get_value()));
		end)
		-- High card
		it("High Card beats low card", function()
			assert.is_true(hand.compare(hand.new("AH KD 3S 5S 6S"):get_value(), hand.new("QS JC 4H 5H 3H"):get_value()));
		end)
	end)
end)

