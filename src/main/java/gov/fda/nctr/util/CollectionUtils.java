package gov.fda.nctr.util;

import java.util.HashSet;
import java.util.Set;

import org.checkerframework.checker.nullness.qual.NonNull;


public class CollectionUtils
{
  public static <T> Set<T> minus(Set<T> set1, Set<T> set2)
  {
    Set<T> res = new HashSet<T>();
    for (T e : set1)
      if (!set2.contains(e))
        res.add(e);
    return res;
  }

  public static <T> Set<T> intersection(Set<T> set1, Set<T> set2)
  {
    Set<T> res = new HashSet<T>();
    for (T e : set1)
      if (set2.contains(e))
        res.add(e);
    return res;
  }

  private CollectionUtils()
  {
  }
}
