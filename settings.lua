-- Feature Table //

local headshots = {

    TargetAim = {
        Enabled = false,
        Target = "None",
        AutoFire = false,
        Strafe = false,
        CSync = false,
        VisualizeStrafe = false,
        VisualizeStrafeColor = Color3.new(155, 125, 175),
        StrafeMethod = "Randomize",
        Highlight = false,
        HighlightFillColor = Color3.new(155, 125, 175),
        HighlightOutlineColor = Color3.new(129, 105, 145),
        Tracer = false,
        TracerPosition = "Mouse",
        TracerFillColor = Color3.new(155, 125, 175),
        TracerOutlineColor = Color3.new(0, 0, 0),
        LookAt = false,
        VoidResolver = false,
        AutoStomp = false,
    },

    KillAura = {
        Enabled = false,
        Keybind = false,
        Distance = 200,
        StompAura = false,
    },

    ExtraESP = {
        MaterialEnabled = false,
        Material = "Neon",
        MaterialColor = Color3.new(255, 255, 255),
        HighlightEnabled = false,
        HighlightFillColor = Color3.new(0, 0, 0),
        HighlightOutlineColor = Color3.new(0, 0, 0),
    },

    CheaterProtection = {
        Enabled = false,
    },

    HitboxExpander = {
        Enabled = false,
        Visualize = false,
        Color = Color3.new(155, 125, 175),
        OutlineColor = Color3.new(155, 125, 175),
        FillTransparency = 0.5,
        OutlineTransparency = 0.3,
        Size = 37,
    },

    Target = {
        AutoKill = false,
        AutoKillDesync = false,
        Target = nil,
    },

    Desync = {
        Enabled = false,
        Keybind = false,
        Visualize = false,
        Tranparency = 0,
        Spam = false,
        InVoid = 0.4,
        OnGround = 0.133,
        Method = "Custom",
    },

    Network = {
        Desync = false,
        UseSenderRate = false,
        SenderRate = 60,
        FakePos = false,
        RefreshRate = 20,
    },

    Speed = {
        Enabled = false,
        Keybind = false,
        Speed = 20,
    },

    Fly = {
        Enabled = false,
        Keybind = false, 
        Speed = 20,
    },

    BulletTracers = {
        Enabled = false,
        TextureID = "rbxassetid://12781852245",
        Color = Color3.new(155, 125, 175),
        Size = 0.4,
        Transparency = 0,
        TimeAlive = 3,
    },

    HitEffects = {
        HitSounds = false,
        HitSoundID = "rbxassetid://97643101798871",
        HitSoundVolume = 5,
        HitNotifications = false,
        HitNotificationsTime = 3,
    },

    AutoReload = {
        Enabled = false,
    },

    AntiStomp = {
        Enabled = false,
    },

    RapidFire = {
        Enabled = false,
    },

    AutoLoadout = {
        Enabled = false,
        Gun = "[Rifle]"
    },

    AutoArmor = {
        Enabled = false,
    },

    SelfVisuals = {
        Character = false,
        CharacterMaterial = "ForceField",
        CharacterColor = Color3.new(155, 125, 175),
        Tool = false,
        ToolMaterial = "ForceField",
        ToolColor = Color3.new(155, 125, 175),
        Aura = false,
        AuraColor = Color3.new(155, 125, 175),
        AuraTexture = "Pink Shyt",
        WalkSteps = false,
        WalkStepsRate = 0.5,
        WalkStepsSize = NumberSequence.new(0, 0.25, 0, 0.5, 1.5, 0, 1, 2, 0),
        WalkStepsColor = Color3.new(255, 255, 255),
    },

}

return headshots
