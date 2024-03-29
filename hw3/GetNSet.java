import java.util.concurrent.atomic.AtomicIntegerArray;

public class GetNSet implements State{
    private byte[] value;
    private byte maxval;
    private AtomicIntegerArray atomicValue;

    GetNSet(byte[] v, byte m) {
        setup(v,m);
    }
    GetNSet(byte[] v) {
        setup(v, (byte)127);
    }
    private void setup(byte[] v, byte m){
        // create the atomic integer array
        atomicValue = new AtomicIntegerArray(v.length);
        for(int i =0; i<v.length; i++){
            atomicValue.set(i, v[i]);
        }
        maxval = m;
        value = v;
    }

    public int size() {
        return atomicValue.length();
    }

    public byte[] current() {
        for (int i=0; i<atomicValue.length(); i++) {
            value[i] = (byte)atomicValue.get(i);
        }
        return value;
    }

    public boolean swap(int i, int j) {
        int ival = atomicValue.get(i);
        int jval = atomicValue.get(j);
        if (ival <= 0 || jval >= maxval) {
            return false;
        }
        atomicValue.set(i, ival-1);
        atomicValue.set(j, jval+1);
        return true;
    }

}