loadfile('deck.lua')();


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
	elseif right.isStraight and right.flush then
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
		return true;
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
