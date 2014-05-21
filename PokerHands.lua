deck ={};
deck["2D"] = {value=2, suite="D"};
deck["3D"] = {value=3, suite="D"};
deck["4D"] = {value=4, suite="D"};
deck["5D"] = {value=5, suite="D"};
deck["6D"] = {value=6, suite="D"};
deck["7D"] = {value=7, suite="D"};
deck["8D"] = {value=8, suite="D"};
deck["9D"] = {value=9, suite="D"};
deck["TD"] = {value=10, suite="D"};
deck["JD"] = {value=11, suite="D"};
deck["QD"] = {value=12, suite="D"};
deck["KD"] = {value=13, suite="D"};
deck["AD"] = {value=14, suite="D"};

deck["2S"] = {value=2, suite="S"};
deck["3S"] = {value=3, suite="S"};
deck["4S"] = {value=4, suite="S"};
deck["5S"] = {value=5, suite="S"};
deck["6S"] = {value=6, suite="S"};
deck["7S"] = {value=7, suite="S"};
deck["8S"] = {value=8, suite="S"};
deck["9S"] = {value=9, suite="S"};
deck["TS"] = {value=10, suite="S"};
deck["JS"] = {value=11, suite="S"};
deck["QS"] = {value=12, suite="S"};
deck["KS"] = {value=13, suite="S"};
deck["AS"] = {value=14, suite="S"};

deck["2C"] = {value=2, suite="C"};
deck["3C"] = {value=3, suite="C"};
deck["4C"] = {value=4, suite="C"};
deck["5C"] = {value=5, suite="C"};
deck["6C"] = {value=6, suite="C"};
deck["7C"] = {value=7, suite="C"};
deck["8C"] = {value=8, suite="C"};
deck["9C"] = {value=9, suite="C"};
deck["TC"] = {value=10, suite="C"};
deck["JC"] = {value=11, suite="C"};
deck["QC"] = {value=12, suite="C"};
deck["KC"] = {value=13, suite="C"};
deck["AC"] = {value=14, suite="C"};

deck["2H"] = {value=2, suite="H"};
deck["3H"] = {value=3, suite="H"};
deck["4H"] = {value=4, suite="H"};
deck["5H"] = {value=5, suite="H"};
deck["6H"] = {value=6, suite="H"};
deck["7H"] = {value=7, suite="H"};
deck["8H"] = {value=8, suite="H"};
deck["9H"] = {value=9, suite="H"};
deck["TH"] = {value=10, suite="H"};
deck["JH"] = {value=11, suite="H"};
deck["QH"] = {value=12, suite="H"};
deck["KH"] = {value=13, suite="H"};
deck["AH"] = {value=14, suite="H"};

deck.compare_cards = function(left_card, right_card)
	return left_card.value > right_card.value;
end

function deepcopy(to, from)
	to = to or {};
	for key, val in pairs(from) do
		if type(val) == "table" then 
			to[key] = to[key] or {};
			deepcopy(to[key], val);
		else
			to[key] = val;
		end
	end
end

hand ={};
hand.cards={};
hand.__index=hand;
-- factory for a hand
-- takes a string representation of a set of cards
-- returns a table representation of that set of cards
hand.new = function(def)
	local output ={};
	output.cards={};
	for card in def:gmatch("(%w%w)") do
		table.insert(output.cards, deck[card]); -- translate card using dicyonary and add to cards
	end
	setmetatable(output, hand);
	return output;
end
-- method for evaluating the value of a hand
-- takes a reference to a hand
-- returns atable repesentation of the the hand which breaks out all it's classification details
hand.get_value= function (self)
	local v ={};
	v.highCard={};
	
	local suite;
	v.isFlush = true;
	for i, card in ipairs(self.cards) do
		table.insert(v.highCard, card.value);
		if 1==i then 
			suite = card.suite;
			
		else
			if suite ~= card.suite then
				v.isFlush = false;
			end
		end
	end
	table.sort(v.highCard, function (a,b) return a>b; end);
	if v.isFlush then
		v.isFlush=v.highCard[1];
	end
	-- identify staright and flush
	
	local previous;
	for i, card in ipairs(v.highCard) do
		if 1==i then
			previous = card;
			v.isStraight = card;
		else
			if card ~= previous-1 then
				v.isStraight = false;
			end
			previous = card;
			
		end
	end
	-- find all matches
	v.matches={};
	local counts={}
	for i, card in ipairs(v.highCard) do
		if nil == counts[card] then 
			counts[card] =1;
		else
			counts[card] = counts[card]+1;
		end
	end
	for height, width in pairs(counts) do
		if 2 <= width then
			table.insert(v.matches, hand.new_match(width, height));
		end
	end
	if 0 == #v.matches then 
		v.matches =false 
	else
		table.sort(v.matches, hand.compare_match)
	end
	
	return v;
end

hand.new_match = function (width, height)
	local output = {width=width or 0, height=height or 0};
	return output;
end

hand.compare_match = function (left, right)
	if left.width == right.width then
		return left.height > right.height;
	else
		return left.width > right.width
	end
end

hand.compare = function (left, right)
	-- straight flush
	if left.isStraight and left.isFlush then
		if right.isStraight and right.isFlush then
			return left.isStraight > right.isStraight;
		else
			return true;
		end
	elseif right.isStraight and right.isFlush then
		return false;
	end
	-- for of a kind
	if left.matches and 4==left.matches[1].width then
		if right.matches and 4==right.matches[1].width then
			return left.matches[1].height > right.matches[1].height;
		else
			return true;
		end
	elseif right.matches and 4==right.matches[1].width then
		return false;
	end
	-- full house
	if left.matches and 2==#left.matches and 3==left.matches[1].width and 2==left.matches[2].width then
		if right.matches and 2==#right.matches and 3==right.matches[1].width and 2==right.matches[2].width then
			if left.matches[1].height == right.matches[1].height then
				return left.matches[2].height > riight.matches[2].height;
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif right.matches and 2==#right.matches and 3==right.matches[1].width and 2==right.matches[2].width then
		return false;
	end
	-- flush
	if left.isFlush then
		if right.isFlush then
			return left.isFlush > right.isFlush;
		else
			return true;
		end
	elseif right.isFlush then
		return false;
	end
	-- straight
	if left.isStraight then
		if right.isStraight then
			return left.isStraight > right.isStraight;
		else
			return true;
		end
	elseif right.isStraight then
		return false;
	end
	-- three of a kind
	if left.matches and 3==left.matches[1].width then
		if right.matches and 3==right.matches[1].width then
			return left.matches[1].height > right.matches[1].height;
		else
			return true;
		end
	elseif right.matches and 3==right.matches[1].width then
		return false;
	end
	-- two pair
	if left.matches and 2==#left.matches and 2==left.matches[1].width and 2==left.matches[2].width then
		if right.matches and 2==#right.matches and 2==right.matches[1].width and 2==right.matches[2].width then
			if left.matches[1].height == right.matches[1].height then
				if left.matches[2].height == left.matches[2].height then
					for i=1,5,1 do
						if left.highCard[i] ~= right.highCard[i] then
							return left.highCard[i]>right.highCard[i];
						end
					end
				else
					return left.matches[2].height > riight.matches[2].height;
				end
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif right.matches and 2==#right.matches and 2==right.matches[1].width and 2==right.matches[2].width then
		return false;
	end
	-- pair
	if left.matches and 2==left.matches[1].width then
		if right.matches and 2==right.matches[1].width then
			if left.matches[1].height == right.matches[1].height then
				for i=1,5,1 do
					if left.highCard[i] ~= right.highCard[i] then
						return left.highCard[i]>right.highCard[i];
					end
				end
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif right.matches and 2==right.matches[1].width then
		return false;
	end
	-- High card
	for i=1,5,1 do
		if left.highCard[i] ~= right.highCard[i] then
			return left.highCard[i]>right.highCard[i];
		end
	end
	return false;
end

for line in io.lines(arg[1]) do
		local leftString, rightString = line:match("(%w%w %w%w %w%w %w%w %w%w) (%w%w %w%w %w%w %w%w %w%w)");
		local leftHand = hand.new(leftString):get_value();
		local rightHand = hand.new(rightString):get_value();

		if hand.compare(leftHand, rightHand) then
			print("left");
		elseif hand.compare(rightHand, leftHand) then
			print("right");
		else
			print("none");
		end
end