int foo()
{
      int i;
      *(long*)&i = 0;  /* { dg-warning "type-punn" } */
      return i;
}

