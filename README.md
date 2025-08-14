# rage
a small rage plugin(under 150LOC)
just opens a floating window every 5 minutes insulting you 
<br/>
toggle with ```RageToggle```
<br/>
enable with ```Rage```
<br/>
disable with ```Calm```

## Installation
### Lazy
```lazy
return {
    "coding4hours/rage.nvim",
    cmd = { "Rage", "RageToggle", "Calm" },
    opts = {},
}
```

### Vim-plug
```vimplug
Plug 'coding4hours/rage.nvim', { 'on': [ "Rage", "Ragetoggle", "Calm" ] }
```

### vim.pack
```vimpack
vim.pack.add({
    'coding4hours/rage.nvim',
})
```

