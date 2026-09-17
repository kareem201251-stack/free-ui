--[[
    WindUI v1.6.65
    Roblox UI Library for scripts
    Author: Footagesus
    Github: https://github.com/Footagesus/WindUI
    License: MIT
]]

type ConfigType__DARKLUA_TYPE_a = {
    Object: Instance,
    Camera: Instance?,
    Interactive: boolean?,
    Height: number?,
    Focused: boolean,
    Window: any,
    WindUI: any,
    Tab: any,
    Parent: Instance,
}

local Modules = {
    cache = {}, 
    load = function(moduleName)
        if not Modules.cache[moduleName] then 
            Modules.cache[moduleName] = { c = Modules[moduleName]() } 
        end 
        return Modules.cache[moduleName].c 
    end
}

do 
    -- Module A: Shapes / UI Drawing Utility
    function Modules.a()
        local Utils
        local ShapesModule = {
            New = nil,
            Init = nil,
            Shapes = {
                Circle = {
                    Image = "rbxassetid://111665032676235",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 512,
                },
                CircleOutline = {
                    Image = "rbxassetid://108556680453287",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 512,
                },
                CircleGlass = {
                    Image = "rbxassetid://95600044758841",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 512,
                },
                SquircleH = {
                    Image = "rbxassetid://125083578015333",
                    Rect = Rect.new(512, 325, 512, 325),
                    Radius = 325,
                },
                SquircleHOutline = {
                    Image = "rbxassetid://107043713170567",
                    Rect = Rect.new(512, 325, 512, 325),
                    Radius = 325,
                },
                SquircleHGlass = {
                    Image = "rbxassetid://84819521201001",
                    Rect = Rect.new(512, 325, 512, 325),
                    Radius = 325,
                },
                ["SquircleH-TL-TR"] = {
                    Image = "rbxassetid://90680657206619",
                    Rect = Rect.new(807, 512, 807, 512),
                    Radius = 325,
                    AutoChange = false,
                },
                ["SquircleH-BL-BR"] = {
                    Image = "rbxassetid://99216342056719",
                    Rect = Rect.new(0, 512, 0, 512),
                    Radius = 325,
                    AutoChange = false,
                },
                SquircleV = {
                    Image = "rbxassetid://124965260437653",
                    Rect = Rect.new(325, 512, 325, 512),
                    Radius = 325,
                },
                SquircleVOutline = {
                    Image = "rbxassetid://88808835404198",
                    Rect = Rect.new(325, 512, 325, 512),
                    Radius = 325,
                },
                SquircleVGlass = {
                    Image = "rbxassetid://124982801466667",
                    Rect = Rect.new(325, 512, 325, 512),
                    Radius = 325,
                },
                Squircle = {
                    Image = "rbxassetid://89641024074289",
                    Rect = Rect.new(460, 460, 460, 460),
                    Radius = 310,
                },
                SquircleOutline = {
                    Image = "rbxassetid://74029063732681",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 310,
                },
                SquircleGlass = {
                    Image = "rbxassetid://131126436897551",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 310,
                },
                ["Squircle-TL-TR"] = {
                    Image = "rbxassetid://75712142040725",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 310,
                    AutoChange = false,
                },
                ["Squircle-BL-BR"] = {
                    Image = "rbxassetid://83676684425544",
                    Rect = Rect.new(512, 0, 512, 0),
                    Radius = 310,
                    AutoChange = false,
                },
                Square = {
                    Image = "rbxassetid://82909646051652",
                    Rect = Rect.new(512, 512, 512, 512),
                    Radius = 512,
                    AutoChange = false,
                },
            },
        }

        function ShapesModule.Init(self, passedUtils)
            Utils = passedUtils
            return self.New
        end

        function ShapesModule.New(self, radius, shapeType, properties, parent, isButton, useSlice)
            local instanceData = {
                Radius = radius or 0,
                Type = shapeType or "Circle",
                GetRadius = nil,
                GetType = nil,
                SetRadius = nil,
                SetType = nil,
            }

            local typeAliases = {
                ["Glass-0.7"] = "SquircleGlass",
                ["Glass-1"] = "SquircleGlass",
                ["Glass-1.4"] = "SquircleGlass",
                ["Squircle-Outline"] = "SquircleOutline",
            }

            local function GetShape(shapeName)
                return ShapesModule.Shapes[typeAliases[shapeName] or shapeName] or ShapesModule.Shapes.Circle
            end

            local uiObject = Utils.New(isButton and "ImageButton" or "ImageLabel", {
                Image = "",
                ScaleType = useSlice ~= false and "Slice" or nil,
                SliceCenter = instanceData.Type ~= "Squircle" and Rect.new(512, 512, 512, 512) or nil,
                SliceScale = 1,
                ThemeTag = properties and properties.ThemeTag or nil,
                BackgroundTransparency = 1,
            }, parent)

            for key, val in next, properties do
                if not table.find({"ThemeTag"}, key) then
                    uiObject[key] = val
                end
            end

            function instanceData.SetRadius(selfObj, newRadius)
                instanceData.Radius = newRadius
                uiObject.SliceScale = math.max(newRadius / GetShape(instanceData.Type).Radius, 0.0001)
                return instanceData
            end

            function instanceData.SetType(selfObj, newType)
                instanceData.Type = newType
                local shapeData = GetShape(newType)
                uiObject.Image = shapeData.Image
                uiObject.SliceCenter = shapeData.Rect
                instanceData:SetRadius(instanceData.Radius)
                return instanceData
            end

            function instanceData.GetRadius(selfObj)
                return instanceData.Radius
            end

            function instanceData.GetType(selfObj)
                return instanceData.Type
            end

            instanceData:SetRadius(radius)
            instanceData:SetType(shapeType)

            Utils.AddSignal(uiObject:GetPropertyChangedSignal("AbsoluteSize"), function()
                local shapeData = GetShape(instanceData.Type)
                if shapeData.AutoChange == false then
                    return
                end

                if string.find(instanceData.Type, "Squircle") then
                    local isGlass = string.find(instanceData.Type, "Glass") and "Glass" or nil
                    local isOutline = string.find(instanceData.Type, "Outline") and "Outline" or nil

                    local width = math.round(uiObject.AbsoluteSize.X / Utils.UIScale)
                    local height = math.round(uiObject.AbsoluteSize.Y / Utils.UIScale)

                    local computedRadius = instanceData.Radius ~= 0 and instanceData.Radius or math.min(width, height) / 2
                    local baseRatio = ShapesModule.Shapes.Squircle.Radius / 1024
                    local sizeRatio = computedRadius / math.min(width, height)

                    local targetShape

                    if width > height then
                        targetShape = (sizeRatio >= baseRatio and "SquircleH" or "Squircle") .. (isOutline or isGlass or "")
                    elseif width < height then
                        targetShape = (sizeRatio >= baseRatio and "SquircleV" or "Squircle") .. (isOutline or isGlass or "")
                    else
                        targetShape = (sizeRatio >= baseRatio and "Circle" or "Squircle") .. (isOutline or isGlass or "")
                    end

                    if targetShape ~= instanceData:GetType() then
                        instanceData:SetType(targetShape)
                    end
                end
            end)

            return uiObject, instanceData
        end

        return ShapesModule
    end

    -- Module B: Icon Engine
    function Modules.b()
        local safeCloneRef = (cloneref or clonereference or function(ref) return ref end)
        local IconEngine = safeCloneRef(game:GetService("ReplicatedStorage"):WaitForChild("GetIcons", 99999):InvokeServer())

        local function parseIconString(iconString)
            if type(iconString) == "string" then
                local delimiterPos = iconString:find(":")
                if delimiterPos then
                    return iconString:sub(1, delimiterPos - 1), iconString:sub(delimiterPos + 1)
                end
            end
            return nil, iconString
        end

        function IconEngine.AddIcons(packName, iconsData)
            if type(packName) ~= "string" or type(iconsData) ~= "table" then
                error("AddIcons: packName must be string, iconsData must be table")
                return
            end

            if not IconEngine.Icons[packName] then
                IconEngine.Icons[packName] = {
                    Icons = {},
                    Spritesheets = {}
                }
            end

            for iconName, data in pairs(iconsData) do
                if type(data) == "number" or (type(data) == "string" and data:match("^rbxassetid://")) then
                    local assetId = type(data) == "number" and ("rbxassetid://" .. tostring(data)) or data

                    IconEngine.Icons[packName].Icons[iconName] = {
                        Image = assetId,
                        ImageRectSize = Vector2.new(0, 0),
                        ImageRectPosition = Vector2.new(0, 0),
                        Parts = nil
                    }
                    IconEngine.Icons[packName].Spritesheets[assetId] = assetId

                elseif type(data) == "table" then
                    if data.Image and data.ImageRectSize and data.ImageRectPosition then
                        local assetId = type(data.Image) == "number" and ("rbxassetid://" .. tostring(data.Image)) or data.Image

                        IconEngine.Icons[packName].Icons[iconName] = {
                            Image = assetId,
                            ImageRectSize = data.ImageRectSize,
                            ImageRectPosition = data.ImageRectPosition,
                            Parts = data.Parts
                        }

                        if not IconEngine.Icons[packName].Spritesheets[assetId] then
                            IconEngine.Icons[packName].Spritesheets[assetId] = assetId
                        end
                    else
                        warn("AddIcons: Invalid spritesheet data format for icon '" .. iconName .. "'")
                    end
                else
                    warn("AddIcons: Unsupported data type for icon '" .. iconName .. "': " .. type(data))
                end
            end
        end

        function IconEngine.SetIconsType(iconType)
            IconEngine.IconsType = iconType
        end

        local elementBuilder
        function IconEngine.Init(builderFunc, themeTag)
            IconEngine.New = builderFunc
            IconEngine.IconThemeTag = themeTag
            elementBuilder = builderFunc
            return IconEngine
        end

        function IconEngine.Icon(iconString, iconType, returnTable)
            returnTable = returnTable ~= false
            local pack, name = parseIconString(iconString)

            local selectedPack = pack or iconType or IconEngine.IconsType
            local selectedName = name
            local iconData = IconEngine.Icons[selectedPack]

            if iconData and iconData.Icons and iconData.Icons[selectedName] then
                return {
                    iconData.Spritesheets[tostring(iconData.Icons[selectedName].Image)],
                    iconData.Icons[selectedName],
                }
            elseif iconData and iconData[selectedName] and string.find(iconData[selectedName], "rbxassetid://") then
                return returnTable and {
                    iconData[selectedName],
                    { ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) }
                } or iconData[selectedName]
            end
            return nil
        end

        function IconEngine.GetIcon(iconString, iconType)
            return IconEngine.Icon(iconString, iconType, false)
        end

        function IconEngine.Icon2(iconString, iconType)
            return IconEngine.Icon(iconString, iconType, true)
        end

        function IconEngine.Image(config)
            local iconProps = {
                Icon = config.Icon or nil,
                Type = config.Type,
                Colors = config.Colors or { (IconEngine.IconThemeTag or Color3.new(1, 1, 1)), Color3.new(1, 1, 1) },
                Transparency = config.Transparency or { 0, 0 },
                Size = config.Size or UDim2.new(0, 24, 0, 24),
                IconFrame = nil,
            }

            local processedColors = {}
            local processedTransparencies = {}

            for idx, col in next, iconProps.Colors do
                processedColors[idx] = {
                    ThemeTag = typeof(col) == "string" and col or nil,
                    Color = typeof(col) == "Color3" and col or nil,
                }
            end

            for idx, trans in next, iconProps.Transparency do
                processedTransparencies[idx] = {
                    ThemeTag = typeof(trans) == "string" and trans or nil,
                    Value = typeof(trans) == "number" and trans or nil,
                }
            end

            local iconResult = IconEngine.Icon2(iconProps.Icon, iconProps.Type)
            local isAssetUrl = typeof(iconResult) == "string" and string.find(iconResult, "rbxassetid://")

            if IconEngine.New then
                local builder = elementBuilder or IconEngine.New

                local imageLabel = builder("ImageLabel", {
                    Size = iconProps.Size,
                    BackgroundTransparency = 1,
                    ImageColor3 = processedColors[1].Color or nil,
                    ImageTransparency = processedTransparencies[1].Value or nil,
                    ThemeTag = processedColors[1].ThemeTag and {
                        ImageColor3 = processedColors[1].ThemeTag,
                        ImageTransparency = processedTransparencies[1].ThemeTag,
                    } or nil,
                    Image = isAssetUrl and iconResult or iconResult[1],
                    ImageRectSize = isAssetUrl and nil or iconResult[2].ImageRectSize,
                    ImageRectOffset = isAssetUrl and nil or iconResult[2].ImageRectPosition,
                })

                if not isAssetUrl and iconResult and iconResult[2].Parts then
                    for partIdx, partName in next, iconResult[2].Parts do
                        local partIcon = IconEngine.Icon(partName, iconProps.Type)

                        builder("ImageLabel", {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            ImageColor3 = processedColors[1 + partIdx].Color or nil,
                            ImageTransparency = processedTransparencies[1 + partIdx].Value or nil,
                            ThemeTag = processedColors[1 + partIdx].ThemeTag and {
                                ImageColor3 = processedColors[1 + partIdx].ThemeTag,
                                ImageTransparency = processedTransparencies[1 + partIdx].ThemeTag,
                            } or nil,
                            Image = partIcon[1],
                            ImageRectSize = partIcon[2].ImageRectSize,
                            ImageRectOffset = partIcon[2].ImageRectPosition,
                            Parent = imageLabel,
                        })
                    end
                end

                iconProps.IconFrame = imageLabel
            else
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Size = iconProps.Size
                imageLabel.BackgroundTransparency = 1
                imageLabel.ImageColor3 = processedColors[1].Color
                imageLabel.ImageTransparency = processedTransparencies[1].Value or nil
                imageLabel.Image = isAssetUrl and iconResult or iconResult[1]
                imageLabel.ImageRectSize = isAssetUrl and nil or iconResult[2].ImageRectSize
                imageLabel.ImageRectOffset = isAssetUrl and nil or iconResult[2].ImageRectPosition

                if not isAssetUrl and iconResult and iconResult[2].Parts then
                    for partIdx, partName in next, iconResult[2].Parts do
                        local partIcon = IconEngine.Icon(partName, iconProps.Type)

                        local subImage = Instance.new("ImageLabel")
                        subImage.Size = UDim2.new(1, 0, 1, 0)
                        subImage.BackgroundTransparency = 1
                        subImage.ImageColor3 = processedColors[1 + partIdx].Color
                        subImage.ImageTransparency = processedTransparencies[1 + partIdx].Value or nil
                        subImage.Image = partIcon[1]
                        subImage.ImageRectSize = partIcon[2].ImageRectSize
                        subImage.ImageRectOffset = partIcon[2].ImageRectPosition
                        subImage.Parent = imageLabel
                    end
                end

                iconProps.IconFrame = imageLabel
            end

            return iconProps
        end

        return IconEngine
    end
end
