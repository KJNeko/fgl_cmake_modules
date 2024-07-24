# /cmake_modules/win32.cmake

if (WIN32)
    set(which_program "where")
    set(os_path_separator "\\")

    function(PlatformPreSetup)
    endfunction()   # PlatformPreSetup

    function(PlatformPostSetup)
    endfunction()   # PlatformPostSetup

endif ()    # if (WIN32)
