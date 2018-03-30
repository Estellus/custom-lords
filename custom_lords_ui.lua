require("custom_lords_tables");

--v function(buttons: vector<TEXT_BUTTON>)
function setUpSingleButtonSelectedGroup(buttons)
    for i, button in ipairs(buttons) do
        button:RegisterForClick(button.name .. "SelectListener",
            function(context)
                for i, otherButton in ipairs(buttons) do
                    if button.name == otherButton.name then
                        otherButton:SetState("selected_hover");
                    else
                        otherButton:SetState("active");
                    end
                end
            end
        );
    end
end

--v function(lordType: string, frame: FRAME) --> TEXT_BUTTON
function createLordTypeButton(lordType, frame)
    local lordTypeButton = TextButton.new(lordType .. "Button", frame, "TEXT_TOGGLE", LORD_TYPE_NAMES[lordType]);
    lordTypeButton:Resize(300, lordTypeButton:Height());
    lordTypeButton:SetState("active");
    return lordTypeButton;
end

--v function(currentFaction: string, frame: FRAME) --> map<string, TEXT_BUTTON>
function createLordTypeButtons(currentFaction, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local buttonsMap = {} --: map<string, TEXT_BUTTON>
    for i, lordType in ipairs(FACTION_LORD_TYPES[currentFaction]) do
        local button = createLordTypeButton(lordType, frame);
        if i == 1 then
            button:SetState("selected");
        end
        buttonsMap[lordType] = button;
        table.insert(buttons, button);
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttonsMap;
end

--v function(skillSet: string, frame: FRAME) --> TEXT_BUTTON
function createSkillSetButton(skillSet, frame)
    local skillSetButton = TextButton.new(skillSet .. "Button", frame, "TEXT_TOGGLE", SKILL_SETS_NAMES[skillSet]);
    skillSetButton:Resize(300, skillSetButton:Height());
    skillSetButton:SetState("active");
    return skillSetButton;
end

--v function(lordType: string, frame: FRAME) --> map<string, TEXT_BUTTON>
function createSkillSetButtons(lordType, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local buttonsMap = {} --: map<string, TEXT_BUTTON>
    for i, skillSet in ipairs(LORD_SKILL_SETS[lordType]) do
        local button = createSkillSetButton(skillSet, frame);
        if i == 1 then
            button:SetState("selected");
        end
        buttonsMap[skillSet] = button;
        table.insert(buttons, button);
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttonsMap;
end

--v function(traitEffectProperties: map<string, string>) --> (string, string)
function calculateImageAndToolTipForTraitEffectProperties(traitEffectProperties)
    local traitImagePath = nil --: string
    local traitDescription = nil --: string
    local colour = nil --: string
    local traitEffect = traitEffectProperties["effect"];
    output("effect: " .. traitEffect);
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
    output("colour: " .. colour);        

    output("traitImagePath: " .. traitImagePath);
    local effectDescriptionPath = "effects_description_" .. traitEffect;
    output("effectDescriptionPath: " .. effectDescriptionPath);
    traitDescription = effect.get_localised_string(effectDescriptionPath);
    output("traitDescription: " .. traitDescription);

    local effectSign = nil --: string
    if effectValue > 0 then
        effectSign = "+";
    else
        effectSign = "";
    end
    traitDescription = string.gsub(traitDescription, "%%%+n", effectSign .. tostring(effectValue));
    traitDescription = string.gsub(traitDescription, "%%%n", tostring(effectValue));    
    output("traitDescription replaced: " .. traitDescription);

    local traitEffectScope = traitEffectProperties["effect_scope"];
    output("traitEffectScope: " .. traitEffectScope);
    local traitEffectScopePath = "campaign_effect_scopes_localised_text_" .. traitEffectScope;
    output("traitEffectScopePath: " .. traitEffectScopePath);
    local traitEffectScopeDesc = effect.get_localised_string(traitEffectScopePath);        
    output("traitEffectScopeDesc: " .. traitEffectScopeDesc);

    traitDescription = "[[col:" .. colour .. "]]" .. traitDescription .. traitEffectScopeDesc .. "[[/col]]";
    output("traitDescription final: " .. traitDescription);

    return traitImagePath, traitDescription;
end

--v function(trait: string, parent: COMPONENT_TYPE | CA_UIC, buttonCreationFunction: function(trait:string, parent: COMPONENT_TYPE | CA_UIC) --> BUTTON) --> CONTAINER
function createTraitRow(trait, parent, buttonCreationFunction)
    output("createTraitRow: " .. trait);
    local traitRow = Container.new(FlowLayout.HORIZONTAL);
    local traitNameKey = "character_trait_levels_onscreen_name_" .. trait;
    output("traitNameKey: " .. traitNameKey);
    local traitName = effect.get_localised_string(traitNameKey);
    output("traitName: " .. traitName);
    local traitNameText = Text.new(trait .. "NameText", parent, "NORMAL", traitName);
    traitRow:AddComponent(traitNameText);
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
    traitRow:AddComponent(buttonCreationFunction(trait, parent));
    return traitRow;
end

--v function(list: vector<string>, value: string) --> boolean
function listContains(list, value)
    for i, listValue in ipairs(list) do
        if listValue == value then
            return true;
        end
    end
    return false;
end

--v function(currentTraits: vector<string>, addTraitCallback: function(string)) --> FRAME
function createTraitSelectionFrame(currentTraits, addTraitCallback)
    local traitSelectionFrame = Frame.new("traitSelectionFrame");
    traitSelectionFrame:SetTitle("Select the Trait to Add");
    --traitSelectionFrame:Scale(0.75);
    local traitSelectionFrameContainer = Container.new(FlowLayout.VERTICAL);
    local traitList = ListView.new("traitList", traitSelectionFrame);
    traitList:Resize(500, traitSelectionFrame:Height() - 100);
    for i, trait in ipairs(TRAITS) do
        local addTraitButtonFunction = function(
            trait, --: string
            parent --: COMPONENT_TYPE | CA_UIC
        )
            local addTraitButton = Button.new("addTraitButton" .. trait, parent, "SQUARE", "ui/skins/default/parchment_header_min.png");
            addTraitButton:RegisterForClick(
                "addTraitButton" .. trait .. "Listener" .. tostring(math.random()),
                function(context)
                    addTraitCallback(trait);
                    Util.delete(traitSelectionFrame.uic);
                end
            )
            return addTraitButton;
        end
        if not listContains(currentTraits, trait) then
            local traitRow = createTraitRow(trait, core:get_ui_root(), addTraitButtonFunction);
            traitList:AddContainer(traitRow);
        end
    end

    local w, h = traitList.listContainer:Bounds();
    output("list container :" .. w .. " " .. h);
    local w, h = traitList.listBox:Bounds();
    output("bounds before:" .. w .. " " .. h);
    traitList.listBox:SetVisible(false);
    traitList.listBox:SetDisabled(true);
    traitList.listBox:SetCanResizeHeight(true);
    traitList.listBox:Resize(traitList.listContainer:Bounds());
    traitList.listBox:SetCanResizeHeight(false);
    traitList.listBox:SetVisible(true);
    traitList.listBox:SetDisabled(false);
    local w, h = traitList.listBox:Bounds();
    output("bounds after:" .. w .. " " .. h);

    -- output_uicomponent(traitList.uic, false);
    -- output_uicomponent(find_uicomponent(traitList.uic, "listview"), false);
    -- output_uicomponent(find_uicomponent(traitList.uic, "list_clip"), false);
    -- output_uicomponent(find_uicomponent(traitList.listBox), false);


    traitSelectionFrameContainer:AddComponent(traitList);
    Util.centreComponentOnComponent(traitSelectionFrameContainer, traitSelectionFrame);
    return traitSelectionFrame;
end

--v function(list: vector<string>, toRemove: string)
function removeFromList(list, toRemove)
    for i, value in ipairs(list) do
        if value == toRemove then
            table.remove(list, i);
            return;
        end
    end
end

--v function(lordTypeButtonsMap: map<string, TEXT_BUTTON>) --> string
function findSelectedLordType(lordTypeButtonsMap)
    local selectedLordType = nil --: string
    for lordType, lordTypeButton in pairs(lordTypeButtonsMap) do
        if lordTypeButton:IsSelected() then
            selectedLordType = lordType;
        end
    end
    return selectedLordType;
end

--v function(skillSetButtonsMap: map<string, TEXT_BUTTON>) --> string
function findSelectedSkillSet(skillSetButtonsMap)
    local selectedSkillSet = nil --: string
    for skillSet, skillSetButton in pairs(skillSetButtonsMap) do
        if skillSetButton:IsSelected() then
            if skillSetButton:Visible() then
                selectedSkillSet = skillSet;
            end
        end
    end
    return selectedSkillSet;
end

--v function(traitButtonMap: map<string, TEXT_BUTTON>) --> string
function findSelectedTrait(traitButtonMap)
    local selectedTrait = nil --: string
    for trait, traitButton in pairs(traitButtonMap) do
        if traitButton:IsSelected() then
            selectedTrait = trait;
        end
    end
    return selectedTrait;
end

--v function(recruitCallback: function(name: string, lordType: string, skillSet: string, traits: vector<string>)) --> FRAME
function createCustomLordFrameUi(recruitCallback)
    local customLordFrame = Frame.new("customLordFrame");
    customLordFrame:SetTitle("Create your custom Lord");
    customLordFrame:Resize(customLordFrame:Width(), customLordFrame:Height() * 1.5);
    --Util.centreComponentOnScreen(customLordFrame);
    customLordFrame:MoveTo(50, 100);

    local frameContainer = Container.new(FlowLayout.VERTICAL);        
    local lordName = Text.new("lordName", customLordFrame, "NORMAL", "Name your Lord");
    frameContainer:AddComponent(lordName);
    local lordNameTextBox = TextBox.new("lordNameTextBox", customLordFrame);
    frameContainer:AddComponent(lordNameTextBox);

    local lordTypeText = Text.new("lordTypeText", customLordFrame, "NORMAL", "Select your Lord type");
    frameContainer:AddComponent(lordTypeText);

    local lordTypeButtons = createLordTypeButtons(cm:get_local_faction(), customLordFrame);
    local buttonContainer = Container.new(FlowLayout.HORIZONTAL);
    for i, button in pairs(lordTypeButtons) do
        buttonContainer:AddComponent(button);
    end
    frameContainer:AddComponent(buttonContainer);

    local skillSetText = Text.new("skillSetText", customLordFrame, "NORMAL", "Select your Lord skill-set");
    frameContainer:AddComponent(skillSetText);

    local skillSetButtonsContainer = Container.new(FlowLayout.HORIZONTAL);
    local lordTypeToSkillSetButtons = {} --: map<string, vector<TEXT_BUTTON>>
    local skillSetToButtonMap = {} --: map<string, TEXT_BUTTON>
    for lordType, lordTypeButton in pairs(lordTypeButtons) do
        lordTypeToSkillSetButtons[lordType] = {};
        local skillSetButtons = createSkillSetButtons(lordType, customLordFrame);
        for skillSet, skillSetButton in pairs(skillSetButtons) do
            skillSetButtonsContainer:AddComponent(skillSetButton);
            table.insert(lordTypeToSkillSetButtons[lordType], skillSetButton);
            skillSetToButtonMap[skillSet] = skillSetButton;
            if lordTypeButton:CurrentState() == "selected" then
                skillSetButton:SetVisible(true);
            else
                skillSetButton:SetVisible(false);
            end
        end
    end
    for lordType, lordTypeButton in pairs(lordTypeButtons) do
        lordTypeButton:RegisterForClick(lordTypeButton.name .. "SkillSetListener",
            function(context)
                for otherLordType, skillSetButtons in pairs(lordTypeToSkillSetButtons) do
                    for i, skillSetButton in ipairs(skillSetButtons) do
                        if otherLordType == lordType then
                            skillSetButton:SetVisible(true);
                        else
                            skillSetButton:SetVisible(false);
                        end
                    end
                end
                Util.centreComponentOnComponent(frameContainer, customLordFrame);
            end
        );
    end
    frameContainer:AddComponent(skillSetButtonsContainer);

    local traitsText = Text.new("traitsText", customLordFrame, "NORMAL", "Select your Lord traits");
    frameContainer:AddComponent(traitsText);

    local selectedTraits = {} --: vector<string>
    table.insert(selectedTraits, "wh2_main_trait_defeated_teclis");
    local traitToRow = {} --: map<string, CONTAINER>            

    local removeTraitButtonFunction = function(
        trait, --: string
        parent --: COMPONENT_TYPE | CA_UIC
    )
        local removeTraitButton = Button.new("removeTraitButton" .. trait .. tostring(math.random()), parent, "SQUARE", "ui/skins/default/parchment_header_max.png");
        removeTraitButton:RegisterForClick(
            "removeTraitButton" .. trait .. "Listener" .. tostring(math.random()),
            function(context)
                removeFromList(selectedTraits, trait);
                traitToRow[trait]:SetVisible(false);
                Util.centreComponentOnComponent(frameContainer, customLordFrame);
            end
        )
        return removeTraitButton;
    end

    local traitRowsContainer = Container.new(FlowLayout.VERTICAL);
    for i, trait in ipairs(selectedTraits) do
        local traitRow = createTraitRow(trait, customLordFrame, removeTraitButtonFunction);
        traitRowsContainer:AddComponent(traitRow);
        traitToRow[trait] = traitRow;
    end
    frameContainer:AddComponent(traitRowsContainer);

    local addTraitButton = TextButton.new("addTraitButton", customLordFrame, "TEXT", "Add Trait");
    addTraitButton:RegisterForClick(
        "addTraitButtonClickListener", 
        function(context)
            local traitSelectionFrame = createTraitSelectionFrame(selectedTraits, 
                function(addedTrait)
                    output("trait added: " .. addedTrait);
                    local traitRow = createTraitRow(addedTrait, customLordFrame, removeTraitButtonFunction);
                    traitRowsContainer:AddComponent(traitRow);
                    traitToRow[addedTrait] = traitRow;
                    table.insert(selectedTraits, addedTrait);
                    Util.centreComponentOnComponent(frameContainer, customLordFrame);
                end
            );
            customLordFrame.uic:Adopt(traitSelectionFrame.uic:Address());
            traitSelectionFrame:PositionRelativeTo(customLordFrame, customLordFrame:Width(), 0);
        end
    );
    frameContainer:AddComponent(addTraitButton);

    Util.centreComponentOnComponent(frameContainer, customLordFrame);

    local region = string.sub(tostring(cm:get_campaign_ui_manager().settlement_selected), 12);
    local settlement = get_region(region):settlement();
    customLordFrame:AddCloseButton(
        function()
            recruitCallback(
                lordNameTextBox.uic:GetStateText(),
                findSelectedLordType(lordTypeButtons),
                findSelectedSkillSet(skillSetToButtonMap),
                selectedTraits
            );
        end
    );

    customLordFrame.uic:PropagatePriority(100);
    return customLordFrame;
end