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