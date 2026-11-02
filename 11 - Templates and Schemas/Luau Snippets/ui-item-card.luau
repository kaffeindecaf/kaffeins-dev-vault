-- Untested: fills a supplied Frame template and returns its clone and cleanup function.
-- Template children: ItemName, DescriptionLabel, ItemThumbnail, ItemPrice, optional ActionButton.
-- Do not use the client callback as proof of ownership or a successful purchase.

local function renderItemCard(template: Frame, parent: Instance, item, options)
	options = options or {}
	assert(item.Id ~= nil, "item.Id is required and should be a stable catalog key")

	local card = template:Clone()
	card.Name = "Item_" .. tostring(item.Id)
	card.Visible = true
	card.Parent = parent

	local function setText(name, value)
		local label = card:FindFirstChild(name, true)
		if label and label:IsA("TextLabel") then label.Text = tostring(value or "") end
	end

	setText("ItemName", item.Name)
	setText("DescriptionLabel", item.Description)
	setText("ItemPrice", options.FormatPrice and options.FormatPrice(item.Price, item.Currency) or tostring(item.Price))

	local thumbnail = card:FindFirstChild("ItemThumbnail", true)
	if thumbnail and thumbnail:IsA("ImageLabel") then
		thumbnail.Image = item.Image or options.PlaceholderImage or ""
		thumbnail.ImageTransparency = item.Image and 0 or 0.35
	end

	local connections = {}
	local actionButton = card:FindFirstChild("ActionButton", true)
	if actionButton and actionButton:IsA("GuiButton") and options.OnActivate then
		table.insert(connections, actionButton.Activated:Connect(function()
			options.OnActivate(item.Id) -- {{SEND_REQUEST_TO_EXISTING_SERVER_AUTHORITY}}
		end))
	end

	return card, function()
		for _, connection in ipairs(connections) do connection:Disconnect() end
		if card.Parent then card:Destroy() end
	end
end

return renderItemCard
