IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
CREATE TABLE [AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [FullName] nvarchar(100) NOT NULL,
    [Address] nvarchar(250) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);

CREATE TABLE [Brands] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(80) NOT NULL,
    [Slug] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_Brands] PRIMARY KEY ([Id])
);

CREATE TABLE [Categories] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(80) NOT NULL,
    [Slug] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [Carts] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Carts_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [Orders] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ReceiverName] nvarchar(100) NOT NULL,
    [PhoneNumber] nvarchar(20) NOT NULL,
    [ShippingAddress] nvarchar(250) NOT NULL,
    [Note] nvarchar(500) NULL,
    [TotalAmount] decimal(18,2) NOT NULL,
    [PaymentMethod] nvarchar(20) NOT NULL,
    [Status] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CheckoutToken] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Orders_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION
);

CREATE TABLE [Products] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(160) NOT NULL,
    [Slug] nvarchar(180) NOT NULL,
    [Description] nvarchar(3000) NOT NULL,
    [Price] decimal(18,2) NOT NULL,
    [BrandId] int NOT NULL,
    [CategoryId] int NOT NULL,
    [IsFeatured] bit NOT NULL,
    [IsActive] bit NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Products_Brands_BrandId] FOREIGN KEY ([BrandId]) REFERENCES [Brands] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE NO ACTION
);

CREATE TABLE [Favorites] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ProductId] int NOT NULL,
    CONSTRAINT [PK_Favorites] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Favorites_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Favorites_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [ProductImages] (
    [Id] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [ImageUrl] nvarchar(1000) NOT NULL,
    [IsPrimary] bit NOT NULL,
    CONSTRAINT [PK_ProductImages] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ProductImages_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [ProductVariants] (
    [Id] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [Size] nvarchar(10) NOT NULL,
    [Color] nvarchar(40) NOT NULL,
    [SKU] nvarchar(60) NOT NULL,
    [StockQuantity] int NOT NULL,
    CONSTRAINT [PK_ProductVariants] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ProductVariants_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [CartItems] (
    [Id] int NOT NULL IDENTITY,
    [CartId] int NOT NULL,
    [ProductVariantId] int NOT NULL,
    [Quantity] int NOT NULL,
    CONSTRAINT [PK_CartItems] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CartItems_Carts_CartId] FOREIGN KEY ([CartId]) REFERENCES [Carts] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CartItems_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([Id]) ON DELETE NO ACTION
);

CREATE TABLE [OrderItems] (
    [Id] int NOT NULL IDENTITY,
    [OrderId] int NOT NULL,
    [ProductVariantId] int NOT NULL,
    [ProductNameSnapshot] nvarchar(160) NOT NULL,
    [SizeSnapshot] nvarchar(10) NOT NULL,
    [ColorSnapshot] nvarchar(40) NOT NULL,
    [UnitPrice] decimal(18,2) NOT NULL,
    [Quantity] int NOT NULL,
    CONSTRAINT [PK_OrderItems] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_OrderItems_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([Id]) ON DELETE NO ACTION
);

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name', N'Slug') AND [object_id] = OBJECT_ID(N'[Brands]'))
    SET IDENTITY_INSERT [Brands] ON;
INSERT INTO [Brands] ([Id], [Name], [Slug])
VALUES (1, N'Nike', N'nike'),
(2, N'Adidas', N'adidas'),
(3, N'Puma', N'puma'),
(4, N'Converse', N'converse'),
(5, N'New Balance', N'new-balance');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name', N'Slug') AND [object_id] = OBJECT_ID(N'[Brands]'))
    SET IDENTITY_INSERT [Brands] OFF;

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name', N'Slug') AND [object_id] = OBJECT_ID(N'[Categories]'))
    SET IDENTITY_INSERT [Categories] ON;
INSERT INTO [Categories] ([Id], [Name], [Slug])
VALUES (1, N'Giày nam', N'giay-nam'),
(2, N'Giày nữ', N'giay-nu'),
(3, N'Giày thể thao', N'giay-the-thao');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name', N'Slug') AND [object_id] = OBJECT_ID(N'[Categories]'))
    SET IDENTITY_INSERT [Categories] OFF;

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'BrandId', N'CategoryId', N'CreatedAt', N'Description', N'IsActive', N'IsFeatured', N'Name', N'Price', N'Slug') AND [object_id] = OBJECT_ID(N'[Products]'))
    SET IDENTITY_INSERT [Products] ON;
INSERT INTO [Products] ([Id], [BrandId], [CategoryId], [CreatedAt], [Description], [IsActive], [IsFeatured], [Name], [Price], [Slug])
VALUES (1, 1, 1, '2026-01-01T00:00:00.0000000Z', N'Air Max Pulse kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'Air Max Pulse', 3290000.0, N'air-max-pulse'),
(2, 1, 2, '2026-01-02T00:00:00.0000000Z', N'Court Vision Low kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Court Vision Low', 2190000.0, N'court-vision-low'),
(3, 1, 3, '2026-01-03T00:00:00.0000000Z', N'Revolution 7 kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Revolution 7', 1790000.0, N'revolution-7'),
(4, 1, 1, '2026-01-04T00:00:00.0000000Z', N'Air Force 1 Shadow kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'Air Force 1 Shadow', 3190000.0, N'air-force-1-shadow'),
(5, 2, 2, '2026-01-05T00:00:00.0000000Z', N'Ultraboost Light kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Ultraboost Light', 4890000.0, N'ultraboost-light'),
(6, 2, 3, '2026-01-06T00:00:00.0000000Z', N'Samba OG kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Samba OG', 2690000.0, N'samba-og'),
(7, 2, 1, '2026-01-07T00:00:00.0000000Z', N'Runfalcon 5 kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'Runfalcon 5', 1590000.0, N'runfalcon-5'),
(8, 2, 2, '2026-01-08T00:00:00.0000000Z', N'Gazelle Bold kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Gazelle Bold', 2890000.0, N'gazelle-bold'),
(9, 3, 3, '2026-01-09T00:00:00.0000000Z', N'RS-X Efekt kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'RS-X Efekt', 2990000.0, N'rs-x-efekt'),
(10, 3, 1, '2026-01-10T00:00:00.0000000Z', N'Velocity Nitro 3 kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'Velocity Nitro 3', 3190000.0, N'velocity-nitro-3'),
(11, 3, 2, '2026-01-11T00:00:00.0000000Z', N'Cali Dream kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Cali Dream', 2390000.0, N'cali-dream'),
(12, 3, 3, '2026-01-12T00:00:00.0000000Z', N'Suede Classic kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Suede Classic', 1990000.0, N'suede-classic'),
(13, 4, 1, '2026-01-13T00:00:00.0000000Z', N'Chuck 70 High kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'Chuck 70 High', 2190000.0, N'chuck-70-high'),
(14, 4, 2, '2026-01-14T00:00:00.0000000Z', N'Run Star Hike kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Run Star Hike', 2590000.0, N'run-star-hike'),
(15, 4, 3, '2026-01-15T00:00:00.0000000Z', N'All Star Move kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'All Star Move', 1890000.0, N'all-star-move'),
(16, 4, 1, '2026-01-16T00:00:00.0000000Z', N'One Star Pro kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'One Star Pro', 2090000.0, N'one-star-pro'),
(17, 5, 2, '2026-01-17T00:00:00.0000000Z', N'Fresh Foam 1080 kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'Fresh Foam 1080', 4590000.0, N'fresh-foam-1080'),
(18, 5, 3, '2026-01-18T00:00:00.0000000Z', N'550 Classic kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'550 Classic', 2890000.0, N'550-classic'),
(19, 5, 1, '2026-01-19T00:00:00.0000000Z', N'327 Heritage kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(1 AS bit), N'327 Heritage', 2790000.0, N'327-heritage'),
(20, 5, 2, '2026-01-20T00:00:00.0000000Z', N'9060 Sea Salt kết hợp thiết kế hiện đại, đệm êm và chất liệu bền bỉ. Phù hợp để đi hằng ngày và vận động.', CAST(1 AS bit), CAST(0 AS bit), N'9060 Sea Salt', 3990000.0, N'9060-sea-salt');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'BrandId', N'CategoryId', N'CreatedAt', N'Description', N'IsActive', N'IsFeatured', N'Name', N'Price', N'Slug') AND [object_id] = OBJECT_ID(N'[Products]'))
    SET IDENTITY_INSERT [Products] OFF;

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'ImageUrl', N'IsPrimary', N'ProductId') AND [object_id] = OBJECT_ID(N'[ProductImages]'))
    SET IDENTITY_INSERT [ProductImages] ON;
INSERT INTO [ProductImages] ([Id], [ImageUrl], [IsPrimary], [ProductId])
VALUES (1, N'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 1),
(2, N'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 2),
(3, N'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 3),
(4, N'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 4),
(5, N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 5),
(6, N'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 6),
(7, N'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 7),
(8, N'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 8),
(9, N'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 9),
(10, N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 10),
(11, N'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 11),
(12, N'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 12),
(13, N'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 13),
(14, N'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 14),
(15, N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 15),
(16, N'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 16),
(17, N'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 17),
(18, N'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 18),
(19, N'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 19),
(20, N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=1000&q=80', CAST(1 AS bit), 20),
(21, N'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 1),
(22, N'https://images.unsplash.com/photo-1512374382149-233c42b6a83b?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 2),
(23, N'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 3),
(24, N'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 4),
(25, N'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 5),
(26, N'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 6),
(27, N'https://images.unsplash.com/photo-1512374382149-233c42b6a83b?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 7),
(28, N'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 8),
(29, N'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 9),
(30, N'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 10),
(31, N'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 11),
(32, N'https://images.unsplash.com/photo-1512374382149-233c42b6a83b?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 12),
(33, N'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 13),
(34, N'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 14),
(35, N'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 15),
(36, N'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 16),
(37, N'https://images.unsplash.com/photo-1512374382149-233c42b6a83b?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 17),
(38, N'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 18),
(39, N'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 19),
(40, N'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=1000&q=80', CAST(0 AS bit), 20);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'ImageUrl', N'IsPrimary', N'ProductId') AND [object_id] = OBJECT_ID(N'[ProductImages]'))
    SET IDENTITY_INSERT [ProductImages] OFF;

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Color', N'ProductId', N'SKU', N'Size', N'StockQuantity') AND [object_id] = OBJECT_ID(N'[ProductVariants]'))
    SET IDENTITY_INSERT [ProductVariants] ON;
INSERT INTO [ProductVariants] ([Id], [Color], [ProductId], [SKU], [Size], [StockQuantity])
VALUES (1, N'Đen', 1, N'SS-01-38-A', N'38', 8),
(2, N'Xanh dương', 1, N'SS-01-38-B', N'38', 11),
(3, N'Đen', 1, N'SS-01-39-A', N'39', 9),
(4, N'Xanh dương', 1, N'SS-01-39-B', N'39', 12),
(5, N'Đen', 1, N'SS-01-40-A', N'40', 10),
(6, N'Xanh dương', 1, N'SS-01-40-B', N'40', 3),
(7, N'Đen', 1, N'SS-01-41-A', N'41', 11),
(8, N'Xanh dương', 1, N'SS-01-41-B', N'41', 4),
(9, N'Đen', 1, N'SS-01-42-A', N'42', 12),
(10, N'Xanh dương', 1, N'SS-01-42-B', N'42', 5),
(11, N'Trắng', 2, N'SS-02-38-A', N'38', 9),
(12, N'Xám', 2, N'SS-02-38-B', N'38', 9),
(13, N'Trắng', 2, N'SS-02-39-A', N'39', 10),
(14, N'Xám', 2, N'SS-02-39-B', N'39', 11),
(15, N'Trắng', 2, N'SS-02-40-A', N'40', 11),
(16, N'Xám', 2, N'SS-02-40-B', N'40', 3),
(17, N'Trắng', 2, N'SS-02-41-A', N'41', 12),
(18, N'Xám', 2, N'SS-02-41-B', N'41', 5),
(19, N'Trắng', 2, N'SS-02-42-A', N'42', 13),
(20, N'Xám', 2, N'SS-02-42-B', N'42', 7),
(21, N'Đen', 3, N'SS-03-38-A', N'38', 10),
(22, N'Xám', 3, N'SS-03-38-B', N'38', 7),
(23, N'Đen', 3, N'SS-03-39-A', N'39', 11),
(24, N'Xám', 3, N'SS-03-39-B', N'39', 10),
(25, N'Đen', 3, N'SS-03-40-A', N'40', 12),
(26, N'Xám', 3, N'SS-03-40-B', N'40', 3),
(27, N'Đen', 3, N'SS-03-41-A', N'41', 13),
(28, N'Xám', 3, N'SS-03-41-B', N'41', 6),
(29, N'Đen', 3, N'SS-03-42-A', N'42', 14),
(30, N'Xám', 3, N'SS-03-42-B', N'42', 9),
(31, N'Trắng', 4, N'SS-04-38-A', N'38', 11),
(32, N'Xanh dương', 4, N'SS-04-38-B', N'38', 5),
(33, N'Trắng', 4, N'SS-04-39-A', N'39', 12),
(34, N'Xanh dương', 4, N'SS-04-39-B', N'39', 9),
(35, N'Trắng', 4, N'SS-04-40-A', N'40', 13),
(36, N'Xanh dương', 4, N'SS-04-40-B', N'40', 3),
(37, N'Trắng', 4, N'SS-04-41-A', N'41', 14),
(38, N'Xanh dương', 4, N'SS-04-41-B', N'41', 7),
(39, N'Trắng', 4, N'SS-04-42-A', N'42', 15),
(40, N'Xanh dương', 4, N'SS-04-42-B', N'42', 11),
(41, N'Đen', 5, N'SS-05-38-A', N'38', 12),
(42, N'Xám', 5, N'SS-05-38-B', N'38', 3);
INSERT INTO [ProductVariants] ([Id], [Color], [ProductId], [SKU], [Size], [StockQuantity])
VALUES (43, N'Đen', 5, N'SS-05-39-A', N'39', 13),
(44, N'Xám', 5, N'SS-05-39-B', N'39', 8),
(45, N'Đen', 5, N'SS-05-40-A', N'40', 14),
(46, N'Xám', 5, N'SS-05-40-B', N'40', 3),
(47, N'Đen', 5, N'SS-05-41-A', N'41', 15),
(48, N'Xám', 5, N'SS-05-41-B', N'41', 8),
(49, N'Đen', 5, N'SS-05-42-A', N'42', 16),
(50, N'Xám', 5, N'SS-05-42-B', N'42', 3),
(51, N'Trắng', 6, N'SS-06-38-A', N'38', 13),
(52, N'Xám', 6, N'SS-06-38-B', N'38', 11),
(53, N'Trắng', 6, N'SS-06-39-A', N'39', 14),
(54, N'Xám', 6, N'SS-06-39-B', N'39', 7),
(55, N'Trắng', 6, N'SS-06-40-A', N'40', 15),
(56, N'Xám', 6, N'SS-06-40-B', N'40', 3),
(57, N'Trắng', 6, N'SS-06-41-A', N'41', 16),
(58, N'Xám', 6, N'SS-06-41-B', N'41', 9),
(59, N'Trắng', 6, N'SS-06-42-A', N'42', 5),
(60, N'Xám', 6, N'SS-06-42-B', N'42', 5),
(61, N'Đen', 7, N'SS-07-38-A', N'38', 14),
(62, N'Xanh dương', 7, N'SS-07-38-B', N'38', 9),
(63, N'Đen', 7, N'SS-07-39-A', N'39', 15),
(64, N'Xanh dương', 7, N'SS-07-39-B', N'39', 6),
(65, N'Đen', 7, N'SS-07-40-A', N'40', 16),
(66, N'Xanh dương', 7, N'SS-07-40-B', N'40', 3),
(67, N'Đen', 7, N'SS-07-41-A', N'41', 5),
(68, N'Xanh dương', 7, N'SS-07-41-B', N'41', 10),
(69, N'Đen', 7, N'SS-07-42-A', N'42', 6),
(70, N'Xanh dương', 7, N'SS-07-42-B', N'42', 7),
(71, N'Trắng', 8, N'SS-08-38-A', N'38', 15),
(72, N'Xám', 8, N'SS-08-38-B', N'38', 7),
(73, N'Trắng', 8, N'SS-08-39-A', N'39', 16),
(74, N'Xám', 8, N'SS-08-39-B', N'39', 5),
(75, N'Trắng', 8, N'SS-08-40-A', N'40', 5),
(76, N'Xám', 8, N'SS-08-40-B', N'40', 3),
(77, N'Trắng', 8, N'SS-08-41-A', N'41', 6),
(78, N'Xám', 8, N'SS-08-41-B', N'41', 11),
(79, N'Trắng', 8, N'SS-08-42-A', N'42', 7),
(80, N'Xám', 8, N'SS-08-42-B', N'42', 9),
(81, N'Đen', 9, N'SS-09-38-A', N'38', 16),
(82, N'Xám', 9, N'SS-09-38-B', N'38', 5),
(83, N'Đen', 9, N'SS-09-39-A', N'39', 5),
(84, N'Xám', 9, N'SS-09-39-B', N'39', 4);
INSERT INTO [ProductVariants] ([Id], [Color], [ProductId], [SKU], [Size], [StockQuantity])
VALUES (85, N'Đen', 9, N'SS-09-40-A', N'40', 6),
(86, N'Xám', 9, N'SS-09-40-B', N'40', 3),
(87, N'Đen', 9, N'SS-09-41-A', N'41', 7),
(88, N'Xám', 9, N'SS-09-41-B', N'41', 12),
(89, N'Đen', 9, N'SS-09-42-A', N'42', 8),
(90, N'Xám', 9, N'SS-09-42-B', N'42', 11),
(91, N'Trắng', 10, N'SS-10-38-A', N'38', 5),
(92, N'Xanh dương', 10, N'SS-10-38-B', N'38', 3),
(93, N'Trắng', 10, N'SS-10-39-A', N'39', 6),
(94, N'Xanh dương', 10, N'SS-10-39-B', N'39', 3),
(95, N'Trắng', 10, N'SS-10-40-A', N'40', 7),
(96, N'Xanh dương', 10, N'SS-10-40-B', N'40', 3),
(97, N'Trắng', 10, N'SS-10-41-A', N'41', 8),
(98, N'Xanh dương', 10, N'SS-10-41-B', N'41', 3),
(99, N'Trắng', 10, N'SS-10-42-A', N'42', 9),
(100, N'Xanh dương', 10, N'SS-10-42-B', N'42', 3),
(101, N'Đen', 11, N'SS-11-38-A', N'38', 6),
(102, N'Xám', 11, N'SS-11-38-B', N'38', 11),
(103, N'Đen', 11, N'SS-11-39-A', N'39', 7),
(104, N'Xám', 11, N'SS-11-39-B', N'39', 12),
(105, N'Đen', 11, N'SS-11-40-A', N'40', 8),
(106, N'Xám', 11, N'SS-11-40-B', N'40', 3),
(107, N'Đen', 11, N'SS-11-41-A', N'41', 9),
(108, N'Xám', 11, N'SS-11-41-B', N'41', 4),
(109, N'Đen', 11, N'SS-11-42-A', N'42', 10),
(110, N'Xám', 11, N'SS-11-42-B', N'42', 5),
(111, N'Trắng', 12, N'SS-12-38-A', N'38', 7),
(112, N'Xám', 12, N'SS-12-38-B', N'38', 9),
(113, N'Trắng', 12, N'SS-12-39-A', N'39', 8),
(114, N'Xám', 12, N'SS-12-39-B', N'39', 11),
(115, N'Trắng', 12, N'SS-12-40-A', N'40', 9),
(116, N'Xám', 12, N'SS-12-40-B', N'40', 3),
(117, N'Trắng', 12, N'SS-12-41-A', N'41', 10),
(118, N'Xám', 12, N'SS-12-41-B', N'41', 5),
(119, N'Trắng', 12, N'SS-12-42-A', N'42', 11),
(120, N'Xám', 12, N'SS-12-42-B', N'42', 7),
(121, N'Đen', 13, N'SS-13-38-A', N'38', 8),
(122, N'Xanh dương', 13, N'SS-13-38-B', N'38', 7),
(123, N'Đen', 13, N'SS-13-39-A', N'39', 9),
(124, N'Xanh dương', 13, N'SS-13-39-B', N'39', 10),
(125, N'Đen', 13, N'SS-13-40-A', N'40', 10),
(126, N'Xanh dương', 13, N'SS-13-40-B', N'40', 3);
INSERT INTO [ProductVariants] ([Id], [Color], [ProductId], [SKU], [Size], [StockQuantity])
VALUES (127, N'Đen', 13, N'SS-13-41-A', N'41', 11),
(128, N'Xanh dương', 13, N'SS-13-41-B', N'41', 6),
(129, N'Đen', 13, N'SS-13-42-A', N'42', 12),
(130, N'Xanh dương', 13, N'SS-13-42-B', N'42', 9),
(131, N'Trắng', 14, N'SS-14-38-A', N'38', 9),
(132, N'Xám', 14, N'SS-14-38-B', N'38', 5),
(133, N'Trắng', 14, N'SS-14-39-A', N'39', 10),
(134, N'Xám', 14, N'SS-14-39-B', N'39', 9),
(135, N'Trắng', 14, N'SS-14-40-A', N'40', 11),
(136, N'Xám', 14, N'SS-14-40-B', N'40', 3),
(137, N'Trắng', 14, N'SS-14-41-A', N'41', 12),
(138, N'Xám', 14, N'SS-14-41-B', N'41', 7),
(139, N'Trắng', 14, N'SS-14-42-A', N'42', 13),
(140, N'Xám', 14, N'SS-14-42-B', N'42', 11),
(141, N'Đen', 15, N'SS-15-38-A', N'38', 10),
(142, N'Xám', 15, N'SS-15-38-B', N'38', 3),
(143, N'Đen', 15, N'SS-15-39-A', N'39', 11),
(144, N'Xám', 15, N'SS-15-39-B', N'39', 8),
(145, N'Đen', 15, N'SS-15-40-A', N'40', 12),
(146, N'Xám', 15, N'SS-15-40-B', N'40', 3),
(147, N'Đen', 15, N'SS-15-41-A', N'41', 13),
(148, N'Xám', 15, N'SS-15-41-B', N'41', 8),
(149, N'Đen', 15, N'SS-15-42-A', N'42', 14),
(150, N'Xám', 15, N'SS-15-42-B', N'42', 3),
(151, N'Trắng', 16, N'SS-16-38-A', N'38', 11),
(152, N'Xanh dương', 16, N'SS-16-38-B', N'38', 11),
(153, N'Trắng', 16, N'SS-16-39-A', N'39', 12),
(154, N'Xanh dương', 16, N'SS-16-39-B', N'39', 7),
(155, N'Trắng', 16, N'SS-16-40-A', N'40', 13),
(156, N'Xanh dương', 16, N'SS-16-40-B', N'40', 3),
(157, N'Trắng', 16, N'SS-16-41-A', N'41', 14),
(158, N'Xanh dương', 16, N'SS-16-41-B', N'41', 9),
(159, N'Trắng', 16, N'SS-16-42-A', N'42', 15),
(160, N'Xanh dương', 16, N'SS-16-42-B', N'42', 5),
(161, N'Đen', 17, N'SS-17-38-A', N'38', 12),
(162, N'Xám', 17, N'SS-17-38-B', N'38', 9),
(163, N'Đen', 17, N'SS-17-39-A', N'39', 13),
(164, N'Xám', 17, N'SS-17-39-B', N'39', 6),
(165, N'Đen', 17, N'SS-17-40-A', N'40', 14),
(166, N'Xám', 17, N'SS-17-40-B', N'40', 3),
(167, N'Đen', 17, N'SS-17-41-A', N'41', 15),
(168, N'Xám', 17, N'SS-17-41-B', N'41', 10);
INSERT INTO [ProductVariants] ([Id], [Color], [ProductId], [SKU], [Size], [StockQuantity])
VALUES (169, N'Đen', 17, N'SS-17-42-A', N'42', 16),
(170, N'Xám', 17, N'SS-17-42-B', N'42', 7),
(171, N'Trắng', 18, N'SS-18-38-A', N'38', 13),
(172, N'Xám', 18, N'SS-18-38-B', N'38', 7),
(173, N'Trắng', 18, N'SS-18-39-A', N'39', 14),
(174, N'Xám', 18, N'SS-18-39-B', N'39', 5),
(175, N'Trắng', 18, N'SS-18-40-A', N'40', 15),
(176, N'Xám', 18, N'SS-18-40-B', N'40', 3),
(177, N'Trắng', 18, N'SS-18-41-A', N'41', 16),
(178, N'Xám', 18, N'SS-18-41-B', N'41', 11),
(179, N'Trắng', 18, N'SS-18-42-A', N'42', 5),
(180, N'Xám', 18, N'SS-18-42-B', N'42', 9),
(181, N'Đen', 19, N'SS-19-38-A', N'38', 14),
(182, N'Xanh dương', 19, N'SS-19-38-B', N'38', 5),
(183, N'Đen', 19, N'SS-19-39-A', N'39', 15),
(184, N'Xanh dương', 19, N'SS-19-39-B', N'39', 4),
(185, N'Đen', 19, N'SS-19-40-A', N'40', 16),
(186, N'Xanh dương', 19, N'SS-19-40-B', N'40', 3),
(187, N'Đen', 19, N'SS-19-41-A', N'41', 5),
(188, N'Xanh dương', 19, N'SS-19-41-B', N'41', 12),
(189, N'Đen', 19, N'SS-19-42-A', N'42', 6),
(190, N'Xanh dương', 19, N'SS-19-42-B', N'42', 11),
(191, N'Trắng', 20, N'SS-20-38-A', N'38', 15),
(192, N'Xám', 20, N'SS-20-38-B', N'38', 3),
(193, N'Trắng', 20, N'SS-20-39-A', N'39', 16),
(194, N'Xám', 20, N'SS-20-39-B', N'39', 3),
(195, N'Trắng', 20, N'SS-20-40-A', N'40', 5),
(196, N'Xám', 20, N'SS-20-40-B', N'40', 3),
(197, N'Trắng', 20, N'SS-20-41-A', N'41', 6),
(198, N'Xám', 20, N'SS-20-41-B', N'41', 3),
(199, N'Trắng', 20, N'SS-20-42-A', N'42', 7),
(200, N'Xám', 20, N'SS-20-42-B', N'42', 3);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Color', N'ProductId', N'SKU', N'Size', N'StockQuantity') AND [object_id] = OBJECT_ID(N'[ProductVariants]'))
    SET IDENTITY_INSERT [ProductVariants] OFF;

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;

CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);

CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);

CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);

CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;

CREATE UNIQUE INDEX [IX_Brands_Slug] ON [Brands] ([Slug]);

CREATE UNIQUE INDEX [IX_CartItems_CartId_ProductVariantId] ON [CartItems] ([CartId], [ProductVariantId]);

CREATE INDEX [IX_CartItems_ProductVariantId] ON [CartItems] ([ProductVariantId]);

CREATE UNIQUE INDEX [IX_Carts_UserId] ON [Carts] ([UserId]);

CREATE UNIQUE INDEX [IX_Categories_Slug] ON [Categories] ([Slug]);

CREATE INDEX [IX_Favorites_ProductId] ON [Favorites] ([ProductId]);

CREATE UNIQUE INDEX [IX_Favorites_UserId_ProductId] ON [Favorites] ([UserId], [ProductId]);

CREATE INDEX [IX_OrderItems_OrderId] ON [OrderItems] ([OrderId]);

CREATE INDEX [IX_OrderItems_ProductVariantId] ON [OrderItems] ([ProductVariantId]);

CREATE UNIQUE INDEX [IX_Orders_CheckoutToken] ON [Orders] ([CheckoutToken]);

CREATE INDEX [IX_Orders_UserId] ON [Orders] ([UserId]);

CREATE UNIQUE INDEX [IX_ProductImages_ProductId_IsPrimary] ON [ProductImages] ([ProductId], [IsPrimary]) WHERE [IsPrimary] = 1;

CREATE INDEX [IX_Products_BrandId] ON [Products] ([BrandId]);

CREATE INDEX [IX_Products_CategoryId] ON [Products] ([CategoryId]);

CREATE UNIQUE INDEX [IX_Products_Slug] ON [Products] ([Slug]);

CREATE UNIQUE INDEX [IX_ProductVariants_ProductId_Size_Color] ON [ProductVariants] ([ProductId], [Size], [Color]);

CREATE UNIQUE INDEX [IX_ProductVariants_SKU] ON [ProductVariants] ([SKU]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260922144015_InitialStore', N'9.0.3');

COMMIT;
GO

