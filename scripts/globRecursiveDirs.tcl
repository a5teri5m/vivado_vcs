
# ディレクトリリストから再帰的にファイルを取得する
proc globRecursiveDirs {dirs masks} {
    set result [list]
    foreach dir $dirs {
        set result [concat $result [globRecursive $dir $masks]]
    }
    return $result
}

# 再帰的にファイルを取得
proc globRecursive {dir masks} {
    set result [list]
    foreach cur [lsort [glob -nocomplain -dir $dir *]] {
        if {[file type $cur] == "directory"} {
            eval lappend result [globRecursive $cur $masks]
        } else {
            foreach mask $masks {
                if {[string match $mask $cur]} {
                    lappend result $cur
                    break
                }
            }
        }
    } 
    return $result 
}



