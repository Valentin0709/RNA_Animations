#include <iostream>
using namespace std;

typedef int NrMare[1000];

NrMare combr[40][40];
//NrMare aux1, aux2, aux3;
NrMare rez1, rez2, rez3, rezc;

void Adunare(NrMare x,NrMare y)
// x = x + y
{
  int i,t=0;
  if(x[0]<y[0])
    x[0]=y[0];
  for(i=1;i<=x[0];i++,t/=10)
  {
    t=x[i]+y[i]+t;
    x[i]=t%10;
    // echivalent x[i]=(t+=x[i]+y[i])%10
  }
  if(t)
    x[++x[0]]=t;
}

void Scadere(NrMare x, NrMare y)
// x <-- x-y
{
  int i,j, t = 0;
  for (i = 1; i <= x[0]; i++)
    if(x[i]>=y[i])
      x[i]-=y[i];
    else
    {
      j=i+1;
      while(x[j]==0)
        x[j++]=9;
      x[j]--;
      x[i]=10+x[i]-y[i];
    }
  for (; x[0] > 1 && !x[x[0]]; x[0]--); // sa n-am zerouri nesemnificative
}

void ProdusMare(NrMare x, NrMare y)
//x = x * y
{
  int i,j,t=0;
  NrMare z;
  //stabilim lungimea rezultatului. S-ar putea modifica
  z[0]=x[0]+y[0]-1;
  //initializez vectorul z
  for(i=1;i<=x[0]+y[0];i++)
    z[i]=0;
  //calculez produsele intermediare, impreuna cu suma intermediara
  for(i=1;i<=x[0];i++)
    for(j=1;j<=y[0];j++)
      z[i+j-1]+=x[i]*y[j];
  //corectez sumele intermediare
  for(i=1;i<=z[0];i++)
  {
    t+=z[i];
    z[i]=t%10;
    t/=10;
  }
  if(t)
    z[++z[0]]=t;
  // pun rezultatul in x
  for(i=0;i<=z[0];i++)
    x[i]=z[i];
}

void AtribMic(NrMare x, int n)
{
  for(int i = 0; i < 1000; i++) x[i] = 0;

  x[0]=0;
  if(n==0)
    x[(x[0]=1)]=0;
  else
    for(;n;n/=10)
      x[++x[0]]=n%10;
}

void AtribMare(NrMare Dest, NrMare Sursa)
{
  int i;
  for(i = 0; i < 1000; i++) Dest[i] = 0;
  for(i=0;i<=Sursa[0];i++)
    Dest[i]=Sursa[i];
}

int Compara(NrMare x, NrMare y)
{
  while(x[0]>1 && x[x[0]]==0)
    x[0]--; //ma asigur ca nu sunt zerouri nesemnificative
  while(y[0]>1 && y[y[0]]==0)
    y[0]--;
  if(x[0]!=y[0])
    return (x[0]<y[0]?-1:1);
  int i=x[0];
  while(x[i]==y[i] && i>0)
    i--;
  if(i==0)
    return 0;
  if(x[i]<y[i])
    return -1;
  return 1;
}

NrMare inc, ok, soli;

void Impartire(NrMare x, NrMare y) {

    AtribMic(inc, 1);
    AtribMic(soli, 0);

    while(Compara(x, y) != -1) {
            Scadere(x, y);
            Adunare(soli ,inc);
    }

    AtribMare(x, soli);

}

void ProdusMic(NrMare x, int n)
//x <- x*n
{
  int i,t=0;
  for(i=1;i<=x[0];i++,t/=10)
  {
    t+=x[i]*n;
    x[i]=t%10;
  }
  for(;t;t/=10)
    x[++x[0]]=t%10;
}

void fact(NrMare rez, int x) {
    AtribMic(rez, 1);

    for(int i = 1; i <= x; i++) ProdusMic(rez, i);
}

void comb(int n, int k) {
 /* AtribMic(aux1, 1); AtribMic(aux2, 1); AtribMic(aux3, 1);

  fact(aux1, n);
  fact(aux2, k);
  fact(aux3, n-k);

  if(Compara(aux2, aux3) == -1) {
      Impartire(aux1, aux3);
      Impartire(aux1, aux2);
  }
  else {
    Impartire(aux1, aux2);
    Impartire(aux1, aux3);
  }

  AtribMare(rezc, aux1); */
  NrMare aux1;

  if(k == 1) AtribMic(rezc, n);
  else {
    if(k == n || k ==0) AtribMic(rezc, 1);
    else {
        if(combr[n][k][0] == 0) {

        comb(n - 1, k - 1);
        AtribMare(aux1, rezc);
        comb(n - 1, k);
        Adunare(rezc, aux1);
        AtribMare(combr[n][k], rezc);
        }
        else AtribMare(rezc, combr[n][k]);
    }
  }

}

void afis(NrMare x) {
 for(int i = x[0]; i >= 1; i--) cout << x[i];
}

int main()
{
     int l;
     NrMare sol;

     AtribMic(sol, 0);

      cin >> l;

     for(int i = 1; i <= l/2; i++) {
        cout << i << " ";

        comb(l, 2*i);
        AtribMare(rez1, rezc);

        afis(rez1);
        cout << " ";

        comb(2*i, i);
        AtribMare(rez2, rezc);
        comb(2*i, i-1);
        AtribMare(rez3, rezc);

        Scadere(rez2, rez3);

        afis(rez2);
        cout << " ";

        ProdusMare(rez1, rez2);

        afis(rez1);
        cout << " ";

        Adunare(sol, rez1);

        afis(sol);
        cout << "\n";
     }

     afis(sol);

     return 0;
}
