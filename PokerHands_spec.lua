require("busted");

describe("hand should exist", function()
	setup(loadfile("PokerHands.lua"));
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
		end)
		it("royal flush beats 4 of a kind", function()
			assert.is_true(hand.compare(royalFlush, fourOf));
		end)
		it("royal flush beats full house", function()
			assert.is_true(hand.compare(royalFlush, fullHouse));
		end)
		it("royal flush beats flush", function()
			assert.is_true(hand.compare(royalFlush, flush));
		end)
		it("royal flush beats straight", function()
			assert.is_true(hand.compare(royalFlush, straight));
		end)
		it("royal flush beats 3 of a kind", function()
			assert.is_true(hand.compare(royalFlush, threeOf));
		end)
		it("royal flush beats 2 pair", function()
			assert.is_true(hand.compare(royalFlush, twoPair));
		end)
		it("royal flush beats pair", function()
			assert.is_true(hand.compare(royalFlush, onePair));
		end)
		it("royal flush beats high card", function()
			assert.is_true(hand.compare(royalFlush, highCard));
		end)
		-- Straight Flush
		it("straight flush beats 4 of a kind", function()
			assert.is_true(hand.compare(straightFlush, fourOf));
		end)
		it("straight flush beats full house", function()
			assert.is_true(hand.compare(straightFlush, fullHouse));
		end)
		it("straight flush beats flush", function()
			assert.is_true(hand.compare(straightFlush, flush));
		end)
		it("straight flush beats straight", function()
			assert.is_true(hand.compare(straightFlush, straight));
		end)
		it("straight flush beats 3 of a kind", function()
			assert.is_true(hand.compare(straightFlush, threeOf));
		end)
		it("straight flush beats 2 pair", function()
			assert.is_true(hand.compare(straightFlush, twoPair));
		end)
		it("straight flush beats pair", function()
			assert.is_true(hand.compare(straightFlush, onePair));
		end)
		it("straight flush beats high card", function()
			assert.is_true(hand.compare(straightFlush, highCard));
		end)
		-- four of a kind
		it("4 of a kind beats full house", function()
			assert.is_true(hand.compare(fourOf, fullHouse));
		end)
		it("4 of a kind beats flush", function()
			assert.is_true(hand.compare(fourOf, flush));
		end)
		it("4 of a kind beats straight", function()
			assert.is_true(hand.compare(fourOf, straight));
		end)
		it("4 of a kind beats 3 of a kind", function()
			assert.is_true(hand.compare(fourOf, threeOf));
		end)
		it("4 of a kind beats 2 pair", function()
			assert.is_true(hand.compare(fourOf, twoPair));
		end)
		it("4 of a kind beats pair", function()
			assert.is_true(hand.compare(fourOf, onePair));
		end)
		it("4 of a kind beats high card", function()
			assert.is_true(hand.compare(fourOf, highCard));
		end)
		-- full house
		it("full house beats flush", function()
			assert.is_true(hand.compare(fullHouse, flush));
		end)
		it("full house beats straight", function()
			assert.is_true(hand.compare(fullHouse, straight));
		end)
		it("full house beats 3 of a kind", function()
			assert.is_true(hand.compare(fullHouse, threeOf));
		end)
		it("full house beats 2 pair", function()
			assert.is_true(hand.compare(fullHouse, twoPair));
		end)
		it("full house beats pair", function()
			assert.is_true(hand.compare(fullHouse, onePair));
		end)
		it("full house beats high card", function()
			assert.is_true(hand.compare(fullHouse, highCard));
		end)
		-- flush
		it("flush beats straight", function()
			assert.is_true(hand.compare(flush, straight));
		end)
		it("flush beats 3 of a kind", function()
			assert.is_true(hand.compare(flush, threeOf));
		end)
		it("flush beats 2 pair", function()
			assert.is_true(hand.compare(flush, twoPair));
		end)
		it("flush beats pair", function()
			assert.is_true(hand.compare(flush, onePair));
		end)
		it("flush beats high card", function()
			assert.is_true(hand.compare(flush, highCard));
		end)
		-- straight
		it("straight beats 3 of a kind", function()
			assert.is_true(hand.compare(straight, threeOf));
		end)
		it("straight beats 2 pair", function()
			assert.is_true(hand.compare(straight, twoPair));
		end)
		it("straight beats pair", function()
			assert.is_true(hand.compare(straight, onePair));
		end)
		it("straight beats high card", function()
			assert.is_true(hand.compare(straight, highCard));
		end)
		-- 3 of a kind
		it("3 of a kind beats 2 pair", function()
			assert.is_true(hand.compare(threeOf, twoPair));
		end)
		it("3 of a kind beats pair", function()
			assert.is_true(hand.compare(threeOf, onePair));
		end)
		it("3 of a kind beats high card", function()
			assert.is_true(hand.compare(threeOf, highCard));
		end)
		-- 2 pair
		it("2 pair beats pair", function()
			assert.is_true(hand.compare(twoPair, onePair));
		end)
		it("2 pair beats high card", function()
			assert.is_true(hand.compare(twoPair, highCard));
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

