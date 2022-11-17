package br.university.sfl;

import static org.junit.Assert.*;

import org.junit.Test;

public class MaxTest {

	@Test
	public final void t1() {
		int[] array = new int[]{1, 2, 3};
		int max = Max.max(array, 3);
		assertEquals(3, max);
	}
	
	@Test
	public final void t2() {
		int[] array = new int[]{5, 5, 6};
		int max = Max.max(array, 3);
		assertEquals(6, max);
	}
	
	@Test
	public final void t3() {
		int[] array = new int[]{2, 1, 10};
		int max = Max.max(array, 3);
		assertEquals(10, max);
	}
	
	@Test
	public final void t4() {
		int[] array = new int[]{4, 3, 2};
		int max = Max.max(array, 3);
		assertEquals(4, max);
	}

	@Test
	public final void t5() {
		int[] array = new int[]{4};
		int max = Max.max(array, 1);
		assertEquals(4, max);
	}

}
