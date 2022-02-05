defmodule Rec_funcs do

    def fibb(n) when n > 1 do
        fibb(n-1) + fibb(n-2)
    end
    def fibb(1) do
        1
    end
    def fibb(0) do
        0
    end
    
    def fact(n) when n > 1 do
    	fact(n - 1) * n
    end
    def fact(1) do
    	1
    end
    
    def num_sum(n) when n >= 10 do
    	num_sum(div(n, 10)) + rem(n, 10)
    end
    def num_sum(n) when n < 10 do
    	n
    end
    
    def task_h(n, i) do
    	cond do
    	    n < 2 -> IO.puts("Odd~n")
    	    n == 2 -> IO.puts("Even~n")
    	    rem(n, i) == 0 -> IO.puts("Odd~n")
    	    div(n, 2) > i -> task_h(n, i+1)
    	    true -> IO.puts("Even~n")
    	end
    end
    
end
