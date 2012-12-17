function! RunCurrentTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call s:SetTestFile()

    call s:DetermineTestRunner()
  endif

  " If the current file is not a test file, run the previously defined file

  call s:ExecCommand( g:bjo_test_runner ." ". g:bjo_test_file )
endfunction

function! RunCurrentLineInTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call s:SetTestFileWithLine()

    call s:DetermineTestRunner()
  end

  call s:ExecCommand("call g:ScreenShellSend(\"". g:bjo_test_runner ." ". g:bjo_test_file ."\")")
endfunction

function! s:SetTestFile()
  let g:bjo_test_file=@%
endfunction

function! s:DetermineTestRunner()
  if match(expand('%'), '\.feature$') != -1
    call s:SetTestRunner("cucumber")
  elseif match(expand('%'), '_spec\.rb$') != -1
    call s:SetTestRunner("rspec --options .rspec-vim")
  else
    call s:SetTestRunner("ruby -Itest")
  endif
endfunction

function! s:SetTestRunner(runner)
  let g:bjo_test_runner=a:runner
endfunction

function! s:SetTestFileWithLine()
  let g:bjo_test_file=@%
  let g:bjo_test_file_line=line(".")
endfunction

function! s:ExecCommand(command)
  if g:ScreenShellActive == 1
    exec "call g:ScreenShellSend(\"". a:command ."\")"
  else
    exec "!".a:command
  endif
endfunction
