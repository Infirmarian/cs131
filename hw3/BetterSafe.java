import java.util.concurrent.atomic.AtomicBoolean;

public class BetterSafe implements State{
    private byte[] value;
    private byte maxval;
    private AtomicBoolean[] aba;
    BetterSafe(byte[] v) {
        setup(v, (byte)127);
    }

    BetterSafe(byte[] v, byte m) {
        setup(v, m);
    }
    private void setup(byte[] v, byte m){
        value = v;
        maxval = m;
        aba = new AtomicBoolean[v.length];
        for(int i =0; i<v.length; i++){
            aba[i] = new AtomicBoolean();
        }
    }

    public int size() { 
        return value.length; 
    }

    public byte[] current() {
        return value;
    }

    public boolean swap(int i, int j) {
        int lower = Math.min(i,j);
        int higher = Math.max(i,j);
        while(true){
            if(aba[lower].compareAndSet(false, true)){
                if(aba[higher].compareAndSet(false, true)){
                    if(value[i] <= 0 || value[j] >=maxval){
                        aba[lower].set(false);
                        aba[higher].set(false);
                        return false;
                    }
                    value[i]--;
                    value[j]++;

                    aba[lower].set(false);
                    aba[higher].set(false);
                    return true;
                }else{
                    aba[lower].set(false); 
                }
            }
            // sleep after each failed lock acquisition
            try{
                Thread.sleep(0, 10);
            }catch(Exception e){
                System.out.println(e);
            }
        }
    }
}
