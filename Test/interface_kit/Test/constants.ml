open GraphicsDefs;;

let kSTR_APP_SIG = "application/x-vnd.BeDTS.MenuWorld";;
let kSTR_APP_NAME = "MenuWorld";;
let kSTR_IERROR = "Internal Error :\n";;
let kSTR_SEPARATOR = "--------------------";;
let kSTR_NO_FULL_MENU_BAR = "Couldn't find the window's menu bar.";;
let kSTR_NO_HIDDEN_MENU_BAR = "Couldn't find the window's hidden menu bar.";;
let kSTR_NO_MENU_VIEW = "Couldn't find the window's menu view";;
let kSTR_NO_STATUS_VIEW = "Couldn't find the window's status view";;
let kSTR_NO_LABEL_CTRL = "Couldn't find the label edit field.";;
let kSTR_NO_HIDE_USER_CHECK = "Couldn't find the hide user menus check box.";;
let kSTR_NO_LARGE_ICON_CHECK = "Couldn't find the large test icons check box.";;
let kSTR_NO_ADDMENU_BUTTON = "Couldn't find the add menu button.";;
let kSTR_NO_ADDITEM_BUTTON = "Couldn't find the add menu item button.";;
let kSTR_NO_DELETE_BUTTON = "Couldn't find the delete button.";;
let kSTR_NO_MENU_OUTLINE = "Couldn't find the menu outline list.";;
let kSTR_NO_MENU_SCROLL_VIEW = "Couldn't find the menu outline list scroll view.";;
let kSTR_MNU_FILE = "File";;
let kSTR_MNU_FILE_ABOUT = "About...";;
let kSTR_MNU_FILE_CLOSE = "Close";;
let kSTR_MNU_TEST = "Test";;
let kSTR_MNU_TEST_ITEM = "Test Item";;
let kSTR_MNU_EMPTY_ITEM = "(Empty menu)";;
let kSTR_LABEL_CTRL = "Label:";;
let kSTR_HIDE_USER_MENUS = "Hide User Menus";;
let kSTR_LARGE_TEST_ICONS = "Large Test Icons";;
let kSTR_ADD_MENU = "Add Menu";;
let kSTR_ADD_ITEM = "Add Item";;
let kSTR_ADD_SEP = "Add Separator";;
let kSTR_DELETE_MENU = "Delete";;
let kSTR_STATUS_DEFAULT = "Status default";;
let kSTR_STATUS_TEST = "Test item selected: ";;
let kSTR_STATUS_USER = "Menu item selected: ";;
let kSTR_STATUS_ADD_MENU = "Added menu: ";;
let kSTR_STATUS_ADD_ITEM = "Added menu item: ";;
let kSTR_STATUS_ADD_SEPARATOR = "Added separator menu item";;
let kSTR_STATUS_DELETE_MENU = "Deleted menu: ";;
let kSTR_STATUS_DELETE_ITEM = "Deleted menu item: ";;
let kSTR_STATUS_DELETE_SEPARATOR = "Deleted separator menu item";;
let kSTR_ABOUT_TITLE = "About MenuWorld";;
let kSTR_ABOUT_BUTTON = "Struth!";;
let kSTR_ABOUT_DESC = "MenuWorld: a menu editing example\n\nHow to use:\n    Type some text into the label field, and	press \"Add Menu\" to add a menu.\n    Select an item in the outline list, and press \"Delete\" to remove it.\n    Select an item in the outline list, type some text into the label field, and press \"Add Item\" to add an item under the selected item. If nothing besides spaces or dashes is typed in, a separator item will be created.\n    \"Hide User Menus\" hides the menus you've generated.\n    \"Large Test Icons\" changes the size of the numbers in the Test menu.";;

let kCMD_FILE_CLOSE = 'W';;
let kCMD_TEST_ICON_SIZE = 'I';;

let kBKG_GREY = { red=216 ; green=216 ; blue=216 ; alpha=0 };;

let kMSG_WIN_ADD_MENU			= Int32.of_string "0x6F57414D"
let kMSG_WIN_DELETE_MENU			= Int32.of_string "0x6F57444D"
let kMSG_VIEW_ADD_MENU			= Int32.of_string "0x6F56414D"
let kMSG_VIEW_DELETE_MENU		= Int32.of_string "0x6F56444D"
let kMSG_VIEW_ADD_ITEM			= Int32.of_string "0x6F564149"
let kMSG_WIN_HIDE_USER_MENUS		= Int32.of_string "0x6F574855"
let kMSG_WIN_LARGE_TEST_ICONS	= Int32.of_string "0x6F57464D"
let kMSG_MENU_OUTLINE_SEL		= Int32.of_string "0x6F534D55"
let kMSG_TEST_ITEM				= Int32.of_string "0x6F57544D"
let kMSG_USER_ITEM				= Int32.of_string "0x6F57554D"
let kMSG_LABEL_EDIT				= Int32.of_string "0x6F4C4544"
