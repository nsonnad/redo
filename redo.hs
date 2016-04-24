import System.Directory (renameFile)
import System.Environment (getArgs)
import System.Exit (ExitCode(..))
import System.IO (hPutStrLn, stderr)
import System.Process

main :: IO ()
main = do
  args <- getArgs
  mapM_ redo args

redo :: String -> IO ()
redo target = do
  let tmp = target ++ "---redoing"
  (_, _, _, ph) <- createProcess $ shell $ "sh " ++ target ++ ".do - - " ++ tmp
  exit <- waitForProcess ph
  case exit of
    ExitSuccess -> do renameFile tmp target
    ExitFailure code -> do hPutStrLn stderr $ "Redo script exited with non-zero exit code: " ++ show code
