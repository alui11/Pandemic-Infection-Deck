function infectionDeckSetUpF(handles)
% Sets up infection deck
% 3/7/16
% Author: Alison Lui


%Recall Cities Cell Array
cities{1} = 'San Fran';
cities{2} = 'Chicago';
cities{3} = 'Montreal';
cities{4} = 'New York';
cities{5} = 'Atlanta';
cities{6} = 'Washington';
cities{7} = 'London';
cities{8} = 'Essen';
cities{9} = 'St. Petersburg';
cities{10} = 'Madrid';
cities{11} = 'Paris';
cities{12} = 'Milan';
cities{13} = 'Los Angeles';
cities{14} = 'Mexico City';
cities{15} = 'Miami';
cities{16} = 'Bogota';
cities{17} = 'Lima';
cities{18} = 'Santiago';
cities{19} = 'Buenos Aires';
cities{20} = 'Sao Paulo';
cities{21} = 'Lagos';
cities{22} = 'Khartoum';
cities{23} = 'Kinshasa';
cities{24} = 'Johannesburg';
cities{25} = 'Algiers';
cities{26} = 'Istanbul';
cities{27} = 'Moscow';
cities{28} = 'Cairo';
cities{29} = 'Baghdad';
cities{30} = 'Tehran';
cities{31} = 'Riyadh';
cities{32} = 'Karachi';
cities{33} = 'Delhi';
cities{34} = 'Mumbai';
cities{35} = 'Kolkata';
cities{36} = 'Chennai';
cities{37} = 'Beijing';
cities{38} = 'Seoul';
cities{39} = 'Shanghai';
cities{40} = 'Tokyo';
cities{41} = 'Hong Kong';
cities{42} = 'Taipei';
cities{43} = 'Osaka';
cities{44} = 'Bangkok';
cities{45} = 'Ho Chi Minh';
cities{46} = 'Manila';
cities{47} = 'Jakarta';
cities{48} = 'Sydney';
setappdata(gcf, 'cities', cities);

%Create deck using structure array
for istep = 1:48
    infectionDeck(istep).name = cities{istep};
    infectionDeck(istep).location = istep;
    if istep <= 12
        infectionDeck(istep).color = 'blue';
    elseif istep <= 24
        infectionDeck(istep).color = 'yellow';
    elseif istep <= 36
        infectionDeck(istep).color = 'black';
    else
        infectionDeck(istep).color = 'red';
    end
end

%Shuffle Deck
shuffledLocation = randperm(48);
for istep = 1:48
    infectionDeck(istep).location = shuffledLocation(istep);
end
setappdata(gcf, 'infectionDeck', infectionDeck);

%Set initial values
setappdata(gcf, 'epidemics', 0);
setappdata(gcf, 'infectionRate', 2);
setappdata(gcf, 'highestLocation', 0);
setappdata(gcf, 'quit', false);
setappdata(gcf, 'ndiscardPile', 0);
