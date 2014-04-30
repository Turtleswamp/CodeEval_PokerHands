-- solution to https://www.codeeval.com/open_challenges/86/



-- defenition for deck
-- global dictionar of cards
-- used to assigns values to cards
-- includes method for comaring cards
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

-- function for comparing 2 cards
-- returns true if the left card is lower value than the left and false otehrwise
-- used for sorting cards in a hand
deck.compare_cards = function(left_card, right_card)
	return left_card.value < right_card.value;
end

-- prototype for a hand of cards
hand ={};
hand.cards={}; 
-- method for evaluating the value of a hand
-- takes a reference to a hand
-- returns atable repesentation of the the hand which breaks out all it's classification details
hand.get_value(self)
	local v ={};
	v.highCard={};
	deepcopy(v.highCard, self.cards);
	table.sort(v.highCard, deck.comapre_cards);
	
	-- find all matches
	
	-- identify staright and flush
	v.isStraight = true;
	v.isFlush = true;
	local suite;
	local previous;
	for i, card in v.highCard do
		if 1=i then
			suite = card.suite;
			previous = card.value;
		else
			if suite ~= card.suite then
				flush = false;
			end
			if card.value ~= previous-1 then
				Streight = false;
			end
			previous = card.value;
		end
	end
			
	
end
hand.__index=hand; -- set as own prototype

-- factory for a hand
-- takes a string representation of a set of cards
-- returns a table representation of that set of cards
hand.new = function(def)
	local output ={};
	setmetatable(output, hand);
	for card in def:gmatch("(%w%w)") do
		table.insert(output.cards, deck[card]); -- translate card using dicyonary and add to cards
	end
	return output;
end

-- prototype for a table representation of a hand's value
hand.value ={};
hand.value.matches={};
hand.value.__index=hand.vale;
hand.value.__graterthan = function (left, right)
	-- straight flush
	if left.isStreight and left.isFlush then
		if right.isStraight and right.isFlush then
			return left.isStraight > right.isStraight;
		else
			return true;
		end
	elseif right.isStraight and right.flush then
		return false;
	end
	-- four of a kind
	if 1 == #left.matches and 4 == left.matches[1].width then
		if 1== #right.matches and 4 == right.matches[1].width then
			if left.matches[1].height == right.matches[1].height then
				break;
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif 1 == #right.matches and 4 == right.matches[1].width then
		return false;
	end
	-- full house
	if 2 == #left.matches and 3 == right.matches[1].width then
		if 2 == #right.matches and 3 == right.matches[1].width then
			if left.matches[1].height == right.matches[1].height then
				return left.matches[2].height > right.matches[2].height;
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif 2 == #right.matches and 3 == right.matches[1].width then
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
		return true;
	end
	-- Straight
	if left.isStraight then
		if right.isStriahgt then
			return left.isStraight > right.isStraight;
		else
			return true;
		end
	elseif right.isStraight then
		retunr true;
	end
	-- three of a kind
	if 1 == #left.matches and 3 == left.matches[1].width then
		if 1== #right.matches and 3== right.matches[1]width then
			if left.matches[1].height == right.matches[1].height then
				break;
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif 1 == #right.matches 3 == right.matches[1].width then
		return false;
	end
	-- two pairs
	if 2 == #left.matches then
		if 2 == #right.matches then
			if left.matches[1].height == right.matches[1].height then
				if left.matches[2].height == right.matches[2].height then
					break;
				else
					return left.matches[2].height > right.matches[2].height;
				end
			else
				return left.matches[1].height > left.matches[1].height;
			end
		else
			return true;
		end
	elseif 2== #right.matches then
		return false;
	end
	-- one pair
	if 1==#left.matches then
		if 1==#right.matches then
			if left.matches[1].height == right.matches[1].height then
				break;
			else
				return left.matches[1].height > right.matches[1].height;
			end
		else
			return true;
		end
	elseif 1==#right.matches then
		return false;
	end
	-- hiogh card
	for i=1, #left.highCard, 1 do
		if left.highCard[i] ~= right.highCard[i] then
			return left.highCard[i] > right.higCard[i];
		end
	end
	return false;	
end
-- factory for a table representation of a hnd's value
hand.value.new= function(def)
	local v;
	if def then 
			deepcopy(v, def);
			if v.matches then
				-- makde sure matches are sorted by width then by height
				table.sort(v.matches, function(left, right)
						if left.width > right.width then 
							return true;
						elseif left.width == right.width and left.height > right.height then 
							return true;
						else 
							return false;
						end
					end));
			end
	else
		v={};
	end	
	setmetatable(def, hand.value)
	return def;
end

--deep coppy stolen from Stack Overlfow
local function deepcopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end