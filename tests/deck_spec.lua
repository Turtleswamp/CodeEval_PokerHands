require("busted");

describe("deck should exist", function()
	setup(loadfile("deck.lua"));
	
	it("deck does exist", function()
		assert.not_nil(deck)
	end)
end)