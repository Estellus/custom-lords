require("custom_lords_util");
local TOTAL_TRAIT_POINTS = 2;
MAX_TRAITS = 4;
local CustomLordsTraitFrame = {} --# assume CustomLordsTraitFrame: CUSTOM_LORDS_TRAIT_FRAME
CustomLordsTraitFrame.__index = CustomLordsTraitFrame;
CustomLordsTraitFrame.model = nil --: CUSTOM_LORDS_MODEL
CustomLordsTraitFrame.parentFrame = nil --: FRAME
CustomLordsTraitFrame.addTraitButtons = {} --: map<string, BUTTON>
CustomLordsTraitFrame.traitList = nil --: LIST_VIEW
CustomLordsTraitFrame.traitRows = {} --: map<string, CONTAINER>
CustomLordsTraitFrame.defaultHandleX = 0 --: number
CustomLordsTraitFrame.defaultHandleY = 0 --: number

--v function(traitEffectProperties: map<string, string>) --> (string, string)
function calculateImageAndToolTipForTraitEffectProperties(traitEffectProperties)
    local traitImagePath = nil --: string
    local traitDescription = nil --: string
    local colour = nil --: string
    local traitEffect = traitEffectProperties["effect"];
    local effectValue = tonumber(traitEffectProperties["value"]);
    local effects = TABLES["effects_tables"][traitEffect] --: map<string, string>
    if effectValue > 0 then
        traitImagePath = "ui/campaign ui/effect_bundles/" .. effects["icon"];
    else
        traitImagePath = "ui/campaign ui/effect_bundles/" .. effects["icon_negative"];
    end

    if (effects["is_positive_value_good"] == "True") == (effectValue > 0) then
        colour = "dark_g";
    else
        colour = "dark_r";
    end

    local effectDescriptionPath = "effects_description_" .. traitEffect;
    traitDescription = effect.get_localised_string(effectDescriptionPath);

    local effectSign = nil --: string
    if effectValue > 0 then
        effectSign = "+";
    else
        effectSign = "";
    end
    traitDescription = string.gsub(traitDescription, "%%%+n", effectSign .. tostring(effectValue));
    traitDescription = string.gsub(traitDescription, "%%%n", tostring(effectValue));    

    local traitEffectScope = traitEffectProperties["effect_scope"];
    local traitEffectScopePath = "campaign_effect_scopes_localised_text_" .. traitEffectScope;
    local traitEffectScopeDesc = effect.get_localised_string(traitEffectScopePath);        

    traitDescription = "[[col:" .. colour .. "]]" .. traitDescription .. traitEffectScopeDesc .. "[[/col]]";

    return traitImagePath, traitDescription;
end

--v function(trait:string) --> string
function calculateTraitName(trait)
    local traitNameKey = "character_trait_levels_onscreen_name_" .. trait;
    return effect.get_localised_string(traitNameKey);
end

--v function (trait: string) --> number
function calculateTraitCost(trait)
    return tonumber(TABLES["traits"][trait]["trait_cost"])
end

--v function(trait: string, parent: COMPONENT_TYPE | CA_UIC, buttonCreationFunction: function(trait:string, parent: COMPONENT_TYPE | CA_UIC) --> BUTTON) --> CONTAINER
function createTraitRow(trait, parent, buttonCreationFunction)
    local traitRow = Container.new(FlowLayout.HORIZONTAL);
    local traitName = calculateTraitName(trait);
    local traitNameText = Text.new(trait .. "NameText", parent, "NORMAL", traitName);
    traitNameText:Resize(140, traitNameText:Height());
    traitRow:AddComponent(traitNameText);
    traitRow:AddGap(20);
    local traitEffectsContainer = Container.new(FlowLayout.VERTICAL);
    local traitEffects = TABLES["trait_level_effects_tables"][trait] --: vector<map<string, string>>
    for i, traitEffectProperties in ipairs(traitEffects) do
        local traitEffectContainer = Container.new(FlowLayout.HORIZONTAL);
        local traitImagePath, traitDescription = calculateImageAndToolTipForTraitEffectProperties(traitEffectProperties);
        local traitImage = Image.new(trait .. i .. "Image", parent, traitImagePath);
        traitEffectContainer:AddComponent(traitImage);
        local traitDesc = Text.new(trait .. i .. "NameDesc", parent, "NORMAL", traitDescription);
        traitEffectContainer:AddComponent(traitDesc);
        traitEffectsContainer:AddComponent(traitEffectContainer);
    end
    traitRow:AddComponent(traitEffectsContainer);
    traitRow:AddGap(20);
    local traitCost = calculateTraitCost(trait);
    local traitCostNumberText = nil --: string
    if traitCost > 0 then
        traitCostNumberText = "+" .. traitCost ..  " Trait Points";
    else
        traitCostNumberText = traitCost ..  " Trait Points";
    end
    local traitCostText = Text.new(trait .. "CostText", parent, "NORMAL", traitCostNumberText);
    traitCostText:Resize(100, traitCostText:Height());
    traitRow:AddComponent(traitCostText);
    traitRow:AddComponent(buttonCreationFunction(trait, parent));
    return traitRow;
end

--v function(name: string, parent: COMPONENT_TYPE | CA_UIC, width: number) --> IMAGE
function createTraitDivider(name, parent, width)
    local divider = Image.new(name, parent, "ui/skins/default/separator_line.png")
    divider:Resize(width, 2);
    return divider;
end

--v function(model: CUSTOM_LORDS_MODEL) --> number
function calculateRemainingTraitPoints(model)
    local totalTraitPoints = tonumber(0);
    for i, trait in ipairs(model.selectedTraits) do
        local traitPointsForTrait = tonumber(TABLES["traits"][trait]["trait_cost"]);
        totalTraitPoints = totalTraitPoints + traitPointsForTrait;
    end
    return TOTAL_TRAIT_POINTS + totalTraitPoints;
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME, trait: string) --> boolean
function CustomLordsTraitFrame.shouldDisableAddTraitButton(self, trait)
    local remainingTraitPoints = calculateRemainingTraitPoints(self.model);
    if remainingTraitPoints + calculateTraitCost(trait) < 0 then
        return true;
    elseif listContains(self.model.selectedTraits, trait) then
        return true;
    else
        return false;
    end
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME, firstTrait: string, secondTrait: string) --> boolean
function CustomLordsTraitFrame.compareTraits(self, firstTrait, secondTrait)
    local firstTraitDisabled = self:shouldDisableAddTraitButton(firstTrait);
    local secondTraitDisabled = self:shouldDisableAddTraitButton(secondTrait);
    if firstTraitDisabled == not secondTraitDisabled then
        if firstTraitDisabled then
            return false;
        else
            return true;
        end
    end

    local firstTraitCost = calculateTraitCost(firstTrait);
    local secondTraitCost = calculateTraitCost(secondTrait);
    if firstTraitCost ~= secondTraitCost then
        return firstTraitCost < secondTraitCost;
    end

    local firstTraitName = calculateTraitName(firstTrait);
    local secondTraitName = calculateTraitName(secondTrait);
    return firstTraitName < secondTraitName;
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME) --> vector<string>
function CustomLordsTraitFrame.generateSortedTraitList(self)
    local orderedTraits = {} --: vector<string>
    for trait, traitData in spairs(TABLES["traits"], function(t,a,b) return self:compareTraits(a, b) end) do
        table.insert(orderedTraits, trait);
    end
    return orderedTraits;
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME, addTraitCallback: function(string)) --> FRAME
function CustomLordsTraitFrame.createTraitSelectionFrame(self, addTraitCallback)
    local traitSelectionFrame = Frame.new("traitSelectionFrame");
    traitSelectionFrame:SetTitle("Select the trait to add");
    local traitSelectionFrameContainer = Container.new(FlowLayout.VERTICAL);
    traitSelectionFrame:AddComponent(traitSelectionFrameContainer);
    traitSelectionFrame:AddCloseButton(nil, false, true);
    local traitList = ListView.new("traitList", traitSelectionFrame, "VERTICAL");
    self.traitList = traitList;
    traitList:Resize(600, traitSelectionFrame:Height() - 200);
    local divider = createTraitDivider("SelectFrameTopDivider", traitList, traitSelectionFrame:Width());
    traitList:AddComponent(divider);
    local remainingTraitPoints = calculateRemainingTraitPoints(self.model);
    for trait, traitData in pairs(TABLES["traits"]) do
        local addTraitButtonFunction = function(
            trait, --: string
            parent --: COMPONENT_TYPE | CA_UIC
        )
            local addTraitButton = Button.new("addTraitButton" .. trait, parent, "SQUARE", "ui/skins/default/parchment_header_min.png");
            addTraitButton:RegisterForClick(
                function(context)
                    traitSelectionFrame:SetVisible(false);
                    addTraitCallback(trait);
                end
            )
            addTraitButton:Resize(25, 25);
            addTraitButton:SetDisabled(self:shouldDisableAddTraitButton(trait));
            self.addTraitButtons[trait] = addTraitButton;
            return addTraitButton;
        end
        local traitRow = createTraitRow(trait, traitSelectionFrame, addTraitButtonFunction);
        traitList:AddContainer(traitRow);
        self.traitRows[trait] = traitRow;
        local divider = createTraitDivider(trait .. "Divider", traitList, traitSelectionFrame:Width());
        traitList:AddComponent(divider);
    end
    traitSelectionFrameContainer:AddComponent(traitList);
    Util.centreComponentOnComponent(traitSelectionFrameContainer, traitSelectionFrame);
    self.defaultHandleX, self.defaultHandleY = find_uicomponent(self.traitList.uic, "vslider", "handle"):Position();
    local x, y = traitSelectionFrameContainer:Position();
    return traitSelectionFrame;
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME)
function CustomLordsTraitFrame.sortTraitList(self)
    local orderedTraits = self:generateSortedTraitList();
    local index = 2;
    local dummiesListContainer = self.traitList.dummiesContainer.components;
    for i, trait in ipairs(orderedTraits) do
        dummiesListContainer[index] = self.traitList.containerToDummyMap[self.traitRows[trait]];
        index = index + 2;
    end
    self.traitList.listBox:MoveTo(self.traitList:XPos(), self.traitList:YPos());
    find_uicomponent(self.traitList.uic, "vslider", "handle"):MoveTo(self.defaultHandleX, self.defaultHandleY);
    self.traitList.dummiesContainer:MoveTo(self.traitList.listBox:Position());
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME)
function CustomLordsTraitFrame.update(self)
    for trait, addTraitButton in pairs(self.addTraitButtons) do
        addTraitButton:SetDisabled(self:shouldDisableAddTraitButton(trait));
    end
    self:sortTraitList();
end

--v function(model: CUSTOM_LORDS_MODEL, parentFrame: FRAME, addTraitCallback: function(string)) --> CUSTOM_LORDS_TRAIT_FRAME
function CustomLordsTraitFrame.new(model, parentFrame, addTraitCallback)
    local cltf = {};
    setmetatable(cltf, CustomLordsTraitFrame);
    --# assume cltf: CUSTOM_LORDS_TRAIT_FRAME
    cltf.model = model;
    cltf.parentFrame = parentFrame;
    cltf.traitSelectionFrame = cltf:createTraitSelectionFrame(addTraitCallback);
    cltf:sortTraitList();
    model:RegisterForEvent(
        "SELECTED_TRAITS_CHANGE", 
        function()
            cltf:update();
        end
    );
    return cltf;
end

return {
    new = CustomLordsTraitFrame.new
}