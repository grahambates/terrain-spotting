-- Value noise
-- AKA poor man's Perlin noise!
-- https://en.wikipedia.org/wiki/Value_noise

-- Generate a 512*512 LUT with 5 octaves:

noise={}
size=512 -- noise table width/height

for octave=1,5 do
  -- Geneate random values
  values={}
  for i=1,size^2 do
    values[i]=math.random()
  end

  step=2^octave -- increase step size for each octave in powers of two
  numSteps=size//step -- number of step repetitions in table
  for y=0,size-1 do
    for x=0,size-1 do
      -- Get cells from values grid to interpolate
      x1=(x//step)%numSteps
      y1=(y//step)%numSteps
      x2=(x1+1)%numSteps
      y2=(y1+1)%numSteps
      a=values[x1+y1*numSteps+1] -- upper left cell
      b=values[x2+y1*numSteps+1] -- upper right cell
      c=values[x1+y2*numSteps+1] -- lower left cell
      d=values[x2+y2*numSteps+1] -- lower right cell

      -- 2d interpolation to get current value
      mx=x%step/step
      my=y%step/step
      A=a+(b-a)*mx--^2*(3-2*mx) -- No space for smoothstep - uncomment to enable
      B=c+(d-c)*mx--^2*(3-2*mx)
      v=A+(B-A)*my--^2*(3-2*my)

      -- Accumulate values for each octave in table
      k=x+y*size+1
      noise[k]=(noise[k] or 0)+v
        *step -- multiply by step size so magnitude decreases with frequency
    end
  end
end

t=1
zoom=512
seaLevel=70

TIC=function()
  scroll=300*math.cos(t/300)
  prevY=0

  -- Voxel grid:
  for Z=300,72,-1 do -- range adjusted to cover visible area
    for X=72,-72,-1 do
      -- Lookup Y from noise table:
      local noiseX=(Z+t)%size -- offset by time
      local noiseY=(X-scroll//1)%size -- offset by cos scroll
      local Y=noise[noiseX+noiseY*size+1]+40

      -- Because the scroll offset is applied within the low resolution voxel grid,
      -- shift x by fractional part to counter jerkiness
      local X1=(X+scroll%1)

      if Y>seaLevel then
        -- Water:
        -- Color based on Z depth, and Y of underwater terrain
        color=7+Y/51+Z/70
        -- color=Z/60+(Y/7)%1+7 -- alternate - riple pattern
        -- clamp Y
        Y1=seaLevel
      else
        -- Land:
        -- Color based on Y delta for lighting effect
        color=3+Y-prevY+Z/51
          +(Y/4+Z/2)%1 -- dither
        Y1=Y
      end

      -- Apply perspective and offset to get screen coords
      local x=X1/Z*zoom+120
      local y=Y1/Z*zoom-120

      circ(x,y,2,color)

      prevY=Y
    end
  end
  t=t+1
end
-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
