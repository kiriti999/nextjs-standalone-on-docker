import '@module-federation/nextjs-mf/src/include-defaults';
import SampleComponent from './Sample.component'

export async function getServerSideProps(context: any) {
  return {
    props: {
      
    },
  };
}
export default function SampleComponentMF() {
  return (
    <div>
    <SampleComponent />
    
    </div>
  );
}
