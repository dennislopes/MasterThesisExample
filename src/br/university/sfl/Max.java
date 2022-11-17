package br.university.sfl;

public class Max {
	static int max(int array[], int length)
	{
	int i = 0;
	int max = array[++i]; // Correto: array[i++]
	while (i < length) 
			{
			if (array[i] > max)
				max = array[i];
			i = i + 1;
			}
		System.out.println(max);
		return max;
	}
}